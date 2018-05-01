# Reference

## Classes
* [`harmony`](#harmony): This class installs and configures Cleo Harmony
* [`harmony::config`](#harmonyconfig): 
* [`harmony::dashboard`](#harmonydashboard): harmony::dashboard  This class installs and configures harmony dashboards
* [`harmony::install`](#harmonyinstall): 
* [`harmony::param`](#harmonyparam): 
* [`harmony::service`](#harmonyservice): 
## Classes

### harmony

harmony

This class installs and configuration Cleo Harmony and any dependent packages and modules. If selected, it will also create a user under which the product is installed and database for logging and reporting

#### Examples
##### basic usage
```puppet
include harmony
```


#### Parameters

The following parameters are available in the `harmony` class.

##### `shared_directory`

Data type: `String`

The location of the directory used for user files. This is particularly important for cluster installs.

Default value: $::harmony::param::shared_directory

##### `install_dir`

Data type: `String`

The directory in which to install Harmony

Default value: $::harmony::param::install_dir

##### `user`

Data type: `String`

The user under which the installer should be run

Default value: $::harmony::param::user

##### `group`

Data type: `String`

The name of the group to create, and associate the user with if manage_user is selected

Default value: $::harmony::param::group

##### `group_gid`

Data type: `String`

The id of the group to create if manage_user is selected

Default value: $::harmony::param::group_gid

##### `license_file`

Data type: `String`

The full path and filename of the license_key.txt file to use for licensing

Default value: $::harmony::param::license_file

##### `manage_user`

Data type: `Boolean`

Set to true in order to create the user under which Harmony will be installed

Default value: $::harmony::param::manage_user

##### `database_type`

Data type: `Enum['postgres', 'mysql']`

Type of database to use

Default value: $::harmony::param::database_type

##### `database_host`

Data type: `String`

Hostname for the database to connect to

Default value: $::harmony::param::database_host

##### `database_name`

Data type: `String`

Name of the database to connect to

Default value: $::harmony::param::database_name

##### `database_user`

Data type: `String`

User to use in order to connect to the database

Default value: $::harmony::param::database_user

##### `database_password`

Data type: `String`

Password for connecting to the database

Default value: $::harmony::param::database_password

##### `manage_database`

Data type: `Boolean`

Set to true if you also want puppet to install the underlying database

Default value: $::harmony::param::manage_database

##### `download_url`

Data type: `String`

The URL to download the harmony installer from (including filename)

Default value: $::harmony::param::download_url

##### `patch_base`

Data type: `String`

The base name for the patch to install

Default value: $::harmony::param::patch_base

##### `patch_no`

Data type: `String`

The patch number for the patch to install

Default value: $::harmony::param::patch_no

##### `base_version`

Data type: `String`

The base Harmony version being installed

Default value: $::harmony::param::base_version

##### `ftp_port`

Data type: `Integer`

ftp port to listen on (if do_initial_config is selected)

Default value: $::harmony::param::ftp_port

##### `ftps_port`

Data type: `Integer`

ftps port to listen on (if do_initial_config is selected)

Default value: $::harmony::param::ftps_port

##### `http_port`

Data type: `Integer`

http port to listen on (if do_initial_config is selected)

Default value: $::harmony::param::http_port

##### `https_port`

Data type: `Integer`

https port to listen on (if do_initial_config is selected)

Default value: $::harmony::param::https_port

##### `sftp_port`

Data type: `Integer`

sftp port to listen on (if do_initial_config is selected)

Default value: $::harmony::param::sftp_port

##### `enable_trust`

Data type: `Boolean`

enable trust application (legacy installs only)

Default value: $::harmony::param::enable_trust

##### `enable_unify`

Data type: `Boolean`

enable unify application (legacy installs only)

Default value: $::harmony::param::enable_unify

##### `import_file`

Data type: `String`

configuration file to import (if needed)

Default value: $::harmony::param::import_file

##### `import_password`

Data type: `String`

password for import configuration file

Default value: $::harmony::param::import_password

##### `cert_password`

Data type: `String`

password for certificates in import configuration file (assumed to be all the same)

Default value: $::harmony::param::cert_password

##### `do_initial_config`

Data type: `Boolean`

Perform initial configuration (certificate set up and set up of listening ports etc)

Default value: $::harmony::param::do_initial_config

##### `patch_file_name`

Data type: `String`

Name of the patch file to install

Default value: "${patch_no}.zip"

##### `installer_cache`

Data type: `String`

Local location that installer is cached

Default value: "/vagrant/installers/${installer_name}"

##### `dashboard_cache`

Data type: `String`

Local location that dashboard installer is cached

Default value: "/vagrant/installers/${::harmony::param::dashboard_installer}"

##### `patch_cache`

Data type: `String`

Local location that patches are cached

Default value: "/vagrant/${patch_file_name}"

##### `s3_cache`

Data type: `String`

S3 bucket where installers and patches are cached (to speed up aws installs)

Default value: "${::harmony::param::s3_bucket}/${installer_name}"

##### `s3_dashboard_cache`

Data type: `String`

S3 location of dashboard installer

Default value: "${::harmony::param::s3_bucket}/${::harmony::param::dashboard_installer}"

##### `s3_patch_cache`

Data type: `String`

S3 location of patch installer

Default value: "${::harmony::param::s3_bucket}/${patch_file_name}"

##### `patch_download_url`

Data type: `String`

Base download URL for patches

Default value: "http://www.cleo.com/Web_Install/PatchBase_${::harmony::param::patch_base}/harmony/${patch_no}/${patch_file_name}"

##### `cluster`

Data type: `Boolean`

Should this Harmony be clustered

Default value: $::harmony::param::cluster

##### `cluster_ip`

Data type: `String`

IP address of other machine in the cluster

Default value: $::harmony::param::cluster_ip

##### `cluster_license`

Data type: `String`

License serial number of other machine in the cluster

Default value: $::harmony::param::cluster_license


### harmony::config

The harmony::config class.


### harmony::dashboard

harmony::dashboard

This class installs and configures harmony dashboards

#### Examples
##### Declaring the class
```puppet
include harmony::dashboard
```


### harmony::install

The harmony::install class.


### harmony::param

The harmony::param class.


### harmony::service

The harmony::service class.


