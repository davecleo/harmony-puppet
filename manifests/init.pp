# harmony
#
# This class installs and configuration Cleo Harmony and any dependent packages and modules. If selected, it will also create a user under which the product is installed and database for logging and reporting
#
# @summary This class installs and configures Cleo Harmony
# @example basic usage
#   include harmony
# @param shared_directory   The location of the directory used for user files. This is particularly important for cluster installs.
# @param install_dir   The directory in which to install Harmony 
# @param user   The user under which the installer should be run
# @param group  The name of the group to create, and associate the user with if manage_user is selected
# @param group_gid  The id of the group to create if manage_user is selected
# @param license_file   The full path and filename of the license_key.txt file to use for licensing
# @param manage_user    Set to true in order to create the user under which Harmony will be installed
# @param database_type  Type of database to use
# @param database_host  Hostname for the database to connect to
# @param database_name  Name of the database to connect to
# @param database_user  User to use in order to connect to the database
# @param database_password  Password for connecting to the database
# @param manage_database    Set to true if you also want puppet to install the underlying database
# @param download_url   The URL to download the harmony installer from (including filename)
# @param patch_base The base name for the patch to install
# @param patch_no  The patch number for the patch to install 
# @param base_version   The base Harmony version being installed
# @param ftp_port   ftp port to listen on (if do_initial_config is selected)
# @param ftps_port  ftps port to listen on (if do_initial_config is selected)
# @param http_port  http port to listen on (if do_initial_config is selected)
# @param https_port  https port to listen on (if do_initial_config is selected)
# @param sftp_port  sftp port to listen on (if do_initial_config is selected)
# @param import_file    configuration file to import (if needed)
# @param import_password    password for import configuration file
# @param cert_password  password for certificates in import configuration file (assumed to be all the same)
# @param do_initial_config  Perform initial configuration (certificate set up and set up of listening ports etc)
# @param patch_file_name    Name of the patch file to install
# @param installer_cache    Local location that installer is cached
# @param dashboard_cache    Local location that dashboard installer is cached
# @param patch_cache    Local location that patches are cached
# @param s3_cache   S3 bucket where installers and patches are cached (to speed up aws installs)
# @param s3_dashboard_cache S3 location of dashboard installer
# @param s3_patch_cache S3 location of patch installer
# @param patch_download_url Base download URL for patches
# @param cluster    Should this Harmony be clustered
# @param cluster_ip IP address of other machine in the cluster
# @param cluster_license License serial number of other machine in the cluster
class harmony (
    String $shared_directory                    = $::harmony::param::shared_directory,
    String $install_dir                         = $::harmony::param::install_dir,
    String $user                                = $::harmony::param::user,
    String $group                               = $::harmony::param::group,
    String $group_gid                           = $::harmony::param::group_gid,
    String $license_file                        = $::harmony::param::license_file,
    Boolean $manage_user                        = $::harmony::param::manage_user,
    Enum['postgres', 'mysql'] $database_type    = $::harmony::param::database_type,
    String $database_host                              = $::harmony::param::database_host,
    String $database_name                              = $::harmony::param::database_name,
    String $database_user                              = $::harmony::param::database_user,
    String $database_password                          = $::harmony::param::database_password,
    Boolean $manage_database                            = $::harmony::param::manage_database,
    String $download_url                               = $::harmony::param::download_url,
    String $patch_base                                 = $::harmony::param::patch_base,
    String $patch_no                                   = $::harmony::param::patch_no,
    String $base_version                               = $::harmony::param::base_version,
    Integer $ftp_port                                   = $::harmony::param::ftp_port,
    Integer $ftps_port                                  = $::harmony::param::ftps_port,
    Integer $http_port                                  = $::harmony::param::http_port,
    Integer $https_port                                 = $::harmony::param::https_port,
    Integer $sftp_port                                  = $::harmony::param::sftp_port,
    String $import_file                         = $::harmony::param::import_file,
    String $import_password                     = $::harmony::param::import_password,
    String $cert_password                       = $::harmony::param::cert_password,
    Boolean $do_initial_config                  = $::harmony::param::do_initial_config,
    String $patch_file_name                            = "${patch_no}.zip",
    String $installer_cache                            = "/vagrant/installers/${installer_name}",
    String $dashboard_cache                            = "/vagrant/installers/${::harmony::param::dashboard_installer}",
    String $patch_cache                                = "/vagrant/${patch_file_name}",
    String $s3_cache                                   = "${::harmony::param::s3_bucket}/${installer_name}",
    String $s3_dashboard_cache                         = "${::harmony::param::s3_bucket}/${::harmony::param::dashboard_installer}",
    String $s3_patch_cache                             = "${::harmony::param::s3_bucket}/${patch_file_name}",
    String $patch_download_url                         = "http://www.cleo.com/Web_Install/PatchBase_${::harmony::param::patch_base}/harmony/${patch_no}/${patch_file_name}",
    Boolean $cluster                            = $::harmony::param::cluster,
    String $cluster_ip                          =  $::harmony::param::cluster_ip,
    String $cluster_license                     =  $::harmony::param::cluster_license
) inherits ::harmony::param {
    class{'harmony::install': } ->
    class{'harmony::service': } ->
    class{'harmony::config': }
}
