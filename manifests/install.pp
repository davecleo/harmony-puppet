class harmony::install {

    ensure_packages (['unzip', 'openssl', 'rng-tools', 'wget'],
        { ensure => 'present', })

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


    file { "${harmony::tmp_dir}":
    ensure => 'directory',
    }

    notify {"${harmony::shared_directory}":}

    file { "${harmony::shared_directory}":
        ensure => 'directory',
        owner => "${harmony::user}",
        group => "${harmony::group}",
        require => Exec['run harmony installer'],
    }
    

    file {
            [
            "${harmony::install_dir}/repos",
            "${harmony::install_dir}/repos/unify",
            "${harmony::install_dir}/repos/unify_over",
            "${harmony::install_dir}/repos/trust",
            "${harmony::install_dir}/repos/trust_over",
            ]:
        ensure => 'directory',
    require => Exec['run harmony installer'],
    }

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

    file { "service installer":
        path => '/usr/local/bin/cleo-service',
        ensure => 'present',
        mode => '0700',
        source => "https://raw.githubusercontent.com/jthielens/versalex-ops/master/service/cleo-service",
    }

    file { "harmony license":
        path => "${harmony::install_dir}/license_key.txt",
        ensure => 'present',
        source => "${harmony::license_file}",
        require => Exec['run harmony installer'],
    }

     if $harmony::database_type == 'postgres' {
        file {'postgres jdbc':
             path => "${harmony::install_dir}/lib/ext/postgresql-42.2.1.jar",
             source => 'https://jdbc.postgresql.org/download/postgresql-42.2.1.jar',
             ensure => 'present',
             require => Exec['run harmony installer'],
        }

        if $harmony::manage_database == true {

# the postgres database exists by default, so if we are specifying to use it, we shouldn't do the create

            if $harmony::database_name == 'postgres' {
                class {'postgresql::server': 
                    postgres_password => 'extol',
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

    exec { 'run harmony installer':
        path => '/bin/',
        command => "sh ${harmony::tmp_dir}/${harmony::installer_name} -i silent -DUSER_INSTALL_DIR=${harmony::install_dir}",
        user => $harmony::user,
        creates => "${harmony::install_dir}/Harmonyd",
        require  => [ File['harmony installer'],
                      Package['unzip']
                    ],
    }

    unless $harmony::patch_no == '' {
    transition {'stop harmony service':
        resource => Service['cleod'],
        attributes => {ensure => stopped},
        prior_to => Exec[ 'patch harmony' ],
    }
    }

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

    exec { "install service":
      command => "cleo-service install ${harmony::install_dir} cleod 2>&1 > ${harmony::install_dir}/install.out",
      path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin",
      require => [ 
        File['/usr/local/bin/cleo-service'], 
        Exec['run harmony installer'],
        ],
      unless => 'chkconfig cleod | grep enabled',
    }

    exec { "generate entropy":
        command => "rngd -r /dev/urandom",
        path    => "/sbin:/usr/bin/:/bin/:/usr/sbin",
        require => Package['rng-tools'],
    }

}
