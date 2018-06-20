# harmony
#
# This class installs and configuration Cleo Harmony and any dependent packages and modules. If selected, it will also create a user under which the product is installed and database for logging and reporting
#
# @summary This class installs and configures Cleo Harmony
# @example basic usage
#   include harmony
# @params shared_directory   The location of the directory used for user files. This is particularly important for cluster installs.
# @params install_dir   The directory in which to install Harmony 
# @params user   The user under which the installer should be run
# @params group  The name of the group to create, and associate the user with if manage_user is selected
# @params group_gid  The id of the group to create if manage_user is selected
# @params license_file   The full path and filename of the license_key.txt file to use for licensing
# @params manage_user    Set to true in order to create the user under which Harmony will be installed
# @params database_type  Type of database to use
# @params database_host  Hostname for the database to connect to
# @params database_name  Name of the database to connect to
# @params database_user  User to use in order to connect to the database
# @params database_password  Password for connecting to the database
# @params manage_database    Set to true if you also want puppet to install the underlying database
# @params download_url   The URL to download the harmony installer from (including filename)
# @params patch_base The base name for the patch to install
# @params patch_no  The patch number for the patch to install 
# @params base_version   The base Harmony version being installed
# @params ftp_port   ftp port to listen on (if do_initial_config is selected)
# @params ftps_port  ftps port to listen on (if do_initial_config is selected)
# @params http_port  http port to listen on (if do_initial_config is selected)
# @params https_port  https port to listen on (if do_initial_config is selected)
# @params sftp_port  sftp port to listen on (if do_initial_config is selected)
# @params import_file    configuration file to import (if needed)
# @params import_password    password for import configuration file
# @params cert_password  password for certificates in import configuration file (assumed to be all the same)
# @params do_initial_config  Perform initial configuration (certificate set up and set up of listening ports etc)
# @params patch_file_name    Name of the patch file to install
# @params installer_cache    Local location that installer is cached
# @params dashboard_cache    Local location that dashboard installer is cached
# @params patch_cache    Local location that patches are cached
# @params s3_cache   S3 bucket where installers and patches are cached (to speed up aws installs)
# @params s3_dashboard_cache S3 location of dashboard installer
# @params s3_patch_cache S3 location of patch installer
# @params patch_download_url Base download URL for patches
# @params cluster    Should this Harmony be clustered
# @params cluster_ip IP address of other machine in the cluster
# @params cluster_license License serial number of other machine in the cluster
class harmony (
    String $shared_directory                    = $::harmony::params::shared_directory,
    String $install_dir                         = $::harmony::params::install_dir,
    String $user                                = $::harmony::params::user,
    String $group                               = $::harmony::params::group,
    String $group_gid                           = $::harmony::params::group_gid,
    String $license_file                        = $::harmony::params::license_file,
    Boolean $manage_user                        = $::harmony::params::manage_user,
    Enum['postgres', 'mysql'] $database_type    = $::harmony::params::database_type,
    String $database_host                              = $::harmony::params::database_host,
    String $database_name                              = $::harmony::params::database_name,
    String $database_user                              = $::harmony::params::database_user,
    String $database_password                          = $::harmony::params::database_password,
    Boolean $manage_database                            = $::harmony::params::manage_database,
    String $download_url                               = $::harmony::params::download_url,
    String $patch_base                                 = $::harmony::params::patch_base,
    String $patch_no                                   = $::harmony::params::patch_no,
    String $base_version                               = $::harmony::params::base_version,
    Integer $ftp_port                                   = $::harmony::params::ftp_port,
    Integer $ftps_port                                  = $::harmony::params::ftps_port,
    Integer $http_port                                  = $::harmony::params::http_port,
    Integer $https_port                                 = $::harmony::params::https_port,
    Integer $sftp_port                                  = $::harmony::params::sftp_port,
    String $import_file                         = $::harmony::params::import_file,
    String $import_password                     = $::harmony::params::import_password,
    String $cert_password                       = $::harmony::params::cert_password,
    Boolean $do_initial_config                  = $::harmony::params::do_initial_config,
    String $patch_file_name                            = "${patch_no}.zip",
    String $installer_cache                            = "/vagrant/installers/${installer_name}",
    String $dashboard_cache                            = "/vagrant/installers/${::harmony::params::dashboard_installer}",
    String $patch_cache                                = "/vagrant/${patch_file_name}",
    String $s3_cache                                   = "${::harmony::params::s3_bucket}/${installer_name}",
    String $s3_dashboard_cache                         = "${::harmony::params::s3_bucket}/${::harmony::params::dashboard_installer}",
    String $s3_patch_cache                             = "${::harmony::params::s3_bucket}/${patch_file_name}",
    String $patch_download_url                         = "http://www.cleo.com/Web_Install/PatchBase_${::harmony::params::patch_base}/harmony/${patch_no}/${patch_file_name}",
    Boolean $cluster                            = $::harmony::params::cluster,
    String $cluster_ip                          =  $::harmony::params::cluster_ip,
    String $cluster_license                     =  $::harmony::params::cluster_license
) inherits ::harmony::params {
    class{'harmony::install': } ->
    class{'harmony::service': } ->
    class{'harmony::config': }
}
