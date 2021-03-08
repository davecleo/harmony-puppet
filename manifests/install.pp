class harmony::install {

    ensure_packages (['unzip', 'openssl', 'rng-tools', 'wget', 'fontconfig'],
        { ensure => 'present', })

# Are we setting up a new user to install Harmony under, or using an existing one?
    if harmony::manage_user {
        user { $harmony::user:
            ensure => 'present',
            home => $harmony::install_dir,
            managehome => true,
        }

        group { $harmony::group:
            ensure => 'present',
            gid    => $harmony::group_gid,
        }
    }

# Added for AWS Linux install as needs definted temp directory to work
    file { "${harmony::tmp_dir}":
        ensure => 'directory',
    }

# For cluster installs, need to make sure shared director exists and is owned by the user running Harmony 
    file { "${harmony::shared_directory}":
        ensure => 'directory',
        owner => "${harmony::user}",
        group => "${harmony::group}",
        require => Exec['run harmony installer'],
    }
    
# Get patch file if we are going to patch the install to latest version
# We pull files from a local cache (for fast local installs), an s3 bucket (for AWS) installs 
# or if we can find neither, pull them straight from the download site
    unless $harmony::patch_no == '' {
    file {'harmony patch':
        path => "${harmony::tmp_dir}/${harmony::patch_file_name}",
        source => [
            "${harmony::patch_cache}",
            "${harmony::s3_patch_cache}",
            "${harmony::patch_download_url}"
            ],
        mode => '0700',
        owner => $harmony::user,
        ensure => 'present',
    }
    }

# make sure we've got the installer
    file {'harmony installer':
        path => "${harmony::tmp_dir}/${harmony::installer_name}",
        source => [
            "${harmony::installer_cache}",
            "${harmony::s3_cache}",
            "${harmony::download_url}",
            ],
        mode => '0700',
        owner => $harmony::user,
        ensure => 'present',
    }

# We're using a modified version of the service scripts built by Cleo's CTO
# to enable them to run correctly across a range of linux platforms
    file { "service installer":
        path => '/usr/local/bin/cleo-service',
        ensure => 'present',
        mode => '0700',
        source => "https://raw.githubusercontent.com/jthielens/versalex-ops/master/service/cleo-service",
    }

# Install harmony license file - we need to have this locally
    file { "harmony license":
        path => "${harmony::install_dir}/license_key.txt",
        ensure => 'present',
        source => "${harmony::license_file}",
        require => Exec['run harmony installer'],
    }

# TODO: Extend module to support other database types (mysql etc.)
     if $harmony::database_type == 'postgres' {
        file {'postgres jdbc':
             path => "${harmony::install_dir}/lib/ext/postgresql-42.2.1.jar",
             source => 'https://jdbc.postgresql.org/download/postgresql-42.2.1.jar',
             ensure => 'present',
             require => Exec['run harmony installer'],
        }

# We install postgres on the instance, or not depending on whether manage_postgres is true
        if $harmony::manage_database == true {

# the database named 'postgres' exists by default, so if we are specifying to use it, we shouldn't do the create
            if $harmony::database_name == 'postgres' {
                class {'postgresql::server': 
                    postgres_password => $harmony::database_password,
                }
            } else {
                class {'postgresql::server': 
                    ip_mask_deny_postgres_user => '0.0.0.0/32',
                    ip_mask_allow_all_users => '0.0.0.0/0',
                }
                postgresql::server::db {$harmony::database_name:
                    user => $harmony::database_user,
                    password => postgresql_password($harmony::database_user, $harmony::database_password),
                }
            }
        }
    }

# Execute the Harmony installer
    exec { 'run harmony installer':
        path => '/bin/',
        command => "sh ${harmony::tmp_dir}/${harmony::installer_name} -i silent -DUSER_INSTALL_DIR=${harmony::install_dir}",
        user => $harmony::user,
        creates => "${harmony::install_dir}/Harmonyd",
        require  => [ File['harmony installer'],
                      Package['unzip']
                    ],
    }

# If we are patching, need to stop the service first
    unless $harmony::patch_no == '' {
        transition {'stop harmony service':
            resource => Service['cleod'],
            attributes => {ensure => stopped},
            prior_to => Exec[ 'patch harmony' ],
        }
    }

# Only actually do the patch if it hasn't already been done
    unless $harmony::patch_no == '' {
        exec { 'patch harmony':
            command => "Harmonyc -m -i ${harmony::tmp_dir}/${harmony::patch_file_name}",
            user => $harmony::user,
            path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:${harmony::install_dir}",
            require => [
                File['harmony patch'],
                Exec['run harmony installer'],
            ],
            unless => "/bin/grep ${harmony::base_version}.${harmony::patch_no} ${harmony::install_dir}/conf/version.txt",
        }
    }

# install the service if it isn't ther already
    exec { "install service":
      command => "cleo-service install ${harmony::install_dir} cleod 2>&1 > ${harmony::install_dir}/install.out",
      path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin",
      require => [ 
        File['/usr/local/bin/cleo-service'], 
        Exec['run harmony installer'],
        ],
      unless => 'chkconfig cleod | grep enabled',
    }

# We've had issues in some virtual enviornments with lack of entropy, so generate some just in case
    exec { "generate entropy":
        command => "rngd -r /dev/urandom",
        path    => "/sbin:/usr/bin/:/bin/:/usr/sbin",
        require => Package['rng-tools'],
    }

}
