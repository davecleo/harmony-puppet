# harmony::params
#
# Paramater defaults for the harmony class
#
# @summary This class contains all the default parameter values for the harmony class
# @example basic usage
#   Not used directly, but part of the Harmony module
class harmony::params {
    $shared_directory   = '/home/harmony/local/root'
    $install_dir        = '/home/harmony'
    $download_url       = 'http://www.cleo.com/SoftwareUpdate/harmony/release/jre1.8/InstData/Linux(64-bit)/VM/install.bin'
    $s3_bucket          = 'https://cleo-installers.s3-us-west-2.amazonaws.com'
    $installer_name     = 'Harmony.bin'
    $dashboard_installer= 'Dashboard.bin'
    $base_version       = '5.5'
    $patch_base         = '5.5'
    $patch_no           = '0.1'

    $cluster            = false
    $cluster_ip         = ''
    $cluster_license    = ''
    $user               = 'harmony'
    $group              = 'harmony'
    $group_gid          = '502'
    $manage_user        = true
    $license_file       = '/vagrant/license_key.txt'
    $tmp_dir            = '/tmp/harmony'

    $database_type      = 'postgres'
    $database_name      = 'postgres'
    $database_user      = 'postgres'
    $database_port      = '5432'
    $database_host      = 'localhost'
    $database_password  = 'extol'
    $manage_database    = true
    
    $email_domain   	= 'cleotest.com'

    $ftp_port           = 10021
    $ftps_port          = 10990
    $http_port          = 5080
    $https_port         = 5443
    $sftp_port          = 10022
    
    $import_file        = ''
    $import_password    = ''
    $cert_password      = ''
    $do_initial_config  = true
}
