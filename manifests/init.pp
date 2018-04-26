# harmony
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
# This class installs and configures Cleo Harmony
# @example
#   include harmony
class harmony (
    String $shared_directory                    = $::harmony::param::shared_directory,
    String $install_dir                         = $::harmony::param::install_dir,
    String $user                                = $::harmony::param::user,
    String $group                               = $::harmony::param::group,
    String $group_gid                           = $::harmony::param::group_gid,
    String $license_file                        = $::harmony::param::license_file,
    Boolean $manage_user                        = $::harmony::param::manage_user,
    Enum['postgres', 'mysql'] $database_type    = $::harmony::param::database_type,
    $database_host                              = $::harmony::param::database_host,
    $database_name                              = $::harmony::param::database_name,
    $database_user                              = $::harmony::param::database_user,
    $database_password                          = $::harmony::param::database_password,
    $manage_database                            = $::harmony::param::manage_database,
    $download_url                               = $::harmony::param::download_url,
    $patch_base                                 = $::harmony::param::patch_base,
    $patch_no                                   = $::harmony::param::patch_no,
    $base_version                               = $::harmony::param::base_version,
    $ftp_port                                   = $::harmony::param::ftp_port,
    $ftps_port                                  = $::harmony::param::ftps_port,
    $http_port                                  = $::harmony::param::http_port,
    $https_port                                 = $::harmony::param::https_port,
    $sftp_port                                  = $::harmony::param::sftp_port,
    Boolean $enable_trust                       = $::harmony::param::enable_trust,
    Boolean $enable_unify                       = $::harmony::param::enable_unify,
    String $import_file                         = $::harmony::param::import_file,
    String $import_password                     = $::harmony::param::import_password,
    String $cert_password                       = $::harmony::param::cert_password,
    Boolean $do_initial_config                  = $::harmony::param::do_initial_config,
    $patch_file_name                            = "${patch_no}.zip",
    $installer_cache                            = "/vagrant/installers/${installer_name}",
    $dashboard_cache                            = "/vagrant/installers/${::harmony::param::dashboard_installer}",
    $patch_cache                                = "/vagrant/${patch_file_name}",
    $s3_cache                                   = "${::harmony::param::s3_bucket}/${installer_name}",
    $s3_dashboard_cache                         = "${::harmony::param::s3_bucket}/${::harmony::param::dashboard_installer}",
    $s3_patch_cache                             = "${::harmony::param::s3_bucket}/${patch_file_name}",
    $patch_download_url                         = "http://www.cleo.com/Web_Install/PatchBase_${::harmony::param::patch_base}/harmony/${patch_no}/${patch_file_name}",
    Boolean $cluster                            = $::harmony::param::cluster,
    String $cluster_ip                          =  $::harmony::param::cluster_ip,
    String $cluster_license                     =  $::harmony::param::cluster_license
) inherits ::harmony::param {
    class{'harmony::install': } ->
    class{'harmony::service': } ->
    class{'harmony::config': }
}
