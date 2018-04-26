class harmony::dashboard {
    $db_type = $harmony::database_type ? {
        'postgres' => 'postgresql',
        default => $harmony::database_type,
    }
    $db_string = "${db_type}:${harmony::database_user}:${harmony::database_password}@${harmony::database_host}:${harmony::database_port}/${harmony::database_name}"
    $update_dash_db = @("END")
        /opt/Cleo/Dashboard/jre/bin/java -cp "*" org.apache.derby.tools.ij << EOF
        connect 'jdbc:derby://localhost:1530/dshdb';
        update CIS.EXTDATASRC set DBUSR='${harmony::database_user}', DBURL='${db_string}', DBPW='aT5/rUto6V7gc+LSgM/iwIgQQn9pCy0okCfq9dcNRaFEJ351zn3j9A==';
        quit;
        EOF
        | END

    exec {'update dashboard db':
        cwd => '/opt/Cleo/Dashboard/mrc/production/m-power/dshdb/lib',
        path => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
        command => $update_dash_db,
        require => Service['CleoDashboard'],
    }

    exec { 'install dashboard service':
        command => 'chkconfig --add CleoDashboard',
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
        require => Exec['run dashboard installer'],
        unless => 'chkconfig | grep CleoDashboard',
    }

    file {'dashboard auth':
        path => '/opt/Cleo/Dashboard/mrc/production/m-power/mrcjava/WEB-INF/classes/mrc-spring-context.xml',
        source => '/vagrant/mrc-spring-context.xml',
        ensure => 'present',
        require => Exec['run dashboard installer'],
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
            'http://www.cleo.com/SoftwareUpdate/dashboard/release/jre1.8/InstData/Linux(64-bit)/VM/install.bin',
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
