# harmony::dashboard
#
# This class installs and configures harmony dashboards
#
# @example Declaring the class
#   include harmony::dashboard
#
class harmony::dashboard {
    $db_type = $harmony::database_type ? {
        'postgres' => 'postgresql',
        default => $harmony::database_type,
    }

    exec { 'install dashboard service':
        command => 'chkconfig --add CleoDashboard',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
        require => Exec['run dashboard installer'],
        unless => 'chkconfig | grep CleoDashboard',
    }

    file {'dashboard license':
        path => '/opt/Cleo/Dashboard/mrc/production/m-power/mrcjava/license.jar',
        source => '/vagrant/license.jar',
        ensure => 'present',
        require => Exec['run dashboard installer'],
    }

    file {'dashboard installer':
        path => "${harmony::tmp_dir}/Dashboard.bin",
        source => 
        [
            "${harmony::dashboard_cache}",
            "${harmony::s3_dashboard_cache}",
            'http://download.cleo.com/SoftwareUpdate/dashboard/release/jre1.8/InstData/Linux(64-bit)/VM/install.bin',
        ],
    mode => '0700',
    ensure => 'present',
    }

    exec { 'run dashboard installer':
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
        command => "${harmony::tmp_dir}/Dashboard.bin -i silent",
        creates => '/opt/Cleo/Dashboard/License_Agreement.txt',
    }

    service {'CleoDashboard':
    ensure => 'running',
    require => [ Exec['install dashboard service'],
             File['dashboard license'],
             File['dashboard auth'],
        ],
    } 
}
