class harmony::config {
    $db_type = $harmony::database_type ? {
        'postgres' => 'postgresql',
            default => $harmony::database_type,
    }
    if $harmony::do_initial_config == true {
        file {'shell tool':
            path => "${harmony::install_dir}/shell.sh",
                 source => 'https://raw.githubusercontent.com/jthielens/cleo-core/master/shell.sh',
                 ensure => 'present',
                 mode => '755'
        }

        exec {'update shell':
            command => './shell.sh update',
                    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:${harmony::install_dir}",
                    cwd => "${harmony::install_dir}",
                    require => File['shell tool'],
        }
        $db_string = "${db_type}:${harmony::database_user}:${harmony::database_password}@${harmony::database_host}:${harmony::database_port}/${harmony::database_name}"
        $basic_setup = @("END")
                shell.sh << EOF 
                db set ${db_string}
                xferlog ${db_string}
                set '' replicatelogevents true
                opts Users.xml Users/Usergroup[Administrators]/Vlpoolaccess=mySystem \
                Users/Applications/Dbconnection=${db_string}
                import key SERVER ${harmony::tmp_dir}/server_key.pem ${harmony::tmp_dir}/server_cert.pem cleo
                import key SIGN ${harmony::tmp_dir}/sign_key.pem ${harmony::tmp_dir}/sign_cert.pem cleo
                import key ENCRYPT ${harmony::tmp_dir}/encrypt_key.pem ${harmony::tmp_dir}/encrypt_cert.pem cleo
                scheduler autostart on
                set "Local Listener" Ftpisselected        True
                set "Local Listener" Ftpport                   ${harmony::ftp_port}
                set "Local Listener" Ftpsauthisselected        True
                set "Local Listener" Ftpsauthport              ${harmony::ftps_port}
                set "Local Listener" Ftpsexplicitauthrequiredisselected False
                set "Local Listener" advanced.FTPUTF8Pathnames true
                set "Local Listener" Sslftpservercertalias     SERVER
                set "Local Listener" Sslftpservercertpassword  cleo
                set "Local Listener" Httpisselected            True
                set "Local Listener" Httpsisselected           True
                set "Local Listener" Httpport                  ${harmony::http_port}
                set "Local Listener" Httpsport                 ${harmony::https_port}
                set "Local Listener" Sslservercertalias        SERVER
                set "Local Listener" Sslservercertpassword     cleo
                set "Local Listener" Sshftpisselected          True
                set "Local Listener" Sshftpport                ${harmony::sftp_port}
                set "Local Listener" Sshftpservercertalias     SERVER
                set "Local Listener" Sshftpservercertpassword  cleo
                set "Local Listener" localsigncertalias        SIGN
                set "Local Listener" localsigncertpassword     cleo
                set "Local Listener" localencrcertalias        ENCRYPT
                set "Local Listener" localencrcertpassword     cleo
                save "Local Listener"
                opts VLApplicationNum\(Application='Operator Audit Trail'\) IsEnabled=1
                EOF
                | END

            exec {'create_base_cert':
                command => "openssl req -x509 -subj '/C=US/CN=Harmony' -newkey rsa:2048 -keyout server_key.pem -out server_cert.pem -days 365 -passout pass:'cleo'",
                 cwd     => $harmony::tmp_dir,
                 creates => "${harmony::tmp_dir}/server_cert.pem",
                 path    => ["/usr/bin", "/usr/sbin"],
            }

        exec {'create_encrypt_cert':
            command => "openssl req -x509 -subj '/C=US/CN=ENCRYPT' -newkey rsa:2048 -keyout encrypt_key.pem -out encrypt_cert.pem -days 365 -passout pass:'cleo'",
            cwd     => $harmony::tmp_dir,
            creates => "${harmony::tmp_dir}/encrypt_cert.pem",
            path    => ["/usr/bin", "/usr/sbin"],
        }

        exec {'create_sign_cert':
            command => "openssl req -x509 -subj '/C=US/CN=SIGN' -newkey rsa:2048 -keyout sign_key.pem -out sign_cert.pem -days 365 -passout pass:'cleo'",
            cwd     => $harmony::tmp_dir,
            creates => "${harmony::tmp_dir}/sign_cert.pem",
            path    => ["/usr/bin", "/usr/sbin"]
        }

        exec { 'set up harmony':
            path => "/sbin:/bin:/usr/sbin:/usr/bin:${harmony::install_dir}",
            cwd => "${harmony::install_dir}",
            command => $basic_setup,
            user => $harmony::user,
        }

        exec {'restart cleod':
            path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin",
            require => Exec['set up harmony'],
            command => 'service cleod restart',
        }
    }

    if ($harmony::import_file != '') and ($harmony::import_password != '') {
        exec { 'import config':
            path => "/sbin:/bin:/usr/sbin:/usr/bin:${harmony::install_dir}",
            cwd => "${harmony::install_dir}",
            command => "Harmonyc -i ${harmony::import_file} -pp ${harmony::import_password} -cp ${harmony::cert_password}",
            user => $harmony::user,
            require => Service['cleod'],
        }

    }
    if ($harmony::cluster) {
        exec {'setup cluster':
            path => "/sbin:/bin:/usr/sbin:/usr/bin",
             command => "sleep 20 ; curl --insecure -uadministrator:Admin -H 'Content-type:application/json' -X POST -d '{\"serial\": \"${harmony::cluster_license}\", \"url\": \"https://${harmony::cluster_ip}:5443\", \"syncpath\": \"certs/*;data/*;conf/Options.xml;conf/Proxies.xml;conf/AS400.xml;conf/WinUnixFolders.xml;conf/Schedule.xml;hosts/Local Listener.xml;hosts/*.xml;conf/TradingPartners.xml;conf/ipbl.xml;importedIDPs/*.xml\", \"backup\": false, \"enabled\": true}' \"https://localhost:5443/api/nodes?username=administrator&password=Admin\"; curl --insecure -uadministrator:Admin -H 'Content-type:application/json' -X POST https://localhost:5443/api/nodes/${harmony::cluster_license}/initialize",
            require => Service['cleod'],
        }
    }
}
