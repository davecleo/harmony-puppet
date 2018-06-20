# Reference

## Classes
* [`harmony`](#harmony): This class installs and configures Cleo Harmony
* [`harmony::config`](#harmonyconfig): 
* [`harmony::dashboard`](#harmonydashboard): harmony::dashboard  This class installs and configures harmony dashboards
* [`harmony::install`](#harmonyinstall): 
* [`harmony::params`](#harmonyparams): This class contains all the default parameter values for the harmony class
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



Default value: $::harmony::params::shared_directory

##### `install_dir`

Data type: `String`



Default value: $::harmony::params::install_dir

##### `user`

Data type: `String`



Default value: $::harmony::params::user

##### `group`

Data type: `String`



Default value: $::harmony::params::group

##### `group_gid`

Data type: `String`



Default value: $::harmony::params::group_gid

##### `license_file`

Data type: `String`



Default value: $::harmony::params::license_file

##### `manage_user`

Data type: `Boolean`



Default value: $::harmony::params::manage_user

##### `database_type`

Data type: `Enum['postgres', 'mysql']`



Default value: $::harmony::params::database_type

##### `database_host`

Data type: `String`



Default value: $::harmony::params::database_host

##### `database_name`

Data type: `String`



Default value: $::harmony::params::database_name

##### `database_user`

Data type: `String`



Default value: $::harmony::params::database_user

##### `database_password`

Data type: `String`



Default value: $::harmony::params::database_password

##### `manage_database`

Data type: `Boolean`



Default value: $::harmony::params::manage_database

##### `download_url`

Data type: `String`



Default value: $::harmony::params::download_url

##### `patch_base`

Data type: `String`



Default value: $::harmony::params::patch_base

##### `patch_no`

Data type: `String`



Default value: $::harmony::params::patch_no

##### `base_version`

Data type: `String`



Default value: $::harmony::params::base_version

##### `ftp_port`

Data type: `Integer`



Default value: $::harmony::params::ftp_port

##### `ftps_port`

Data type: `Integer`



Default value: $::harmony::params::ftps_port

##### `http_port`

Data type: `Integer`



Default value: $::harmony::params::http_port

##### `https_port`

Data type: `Integer`



Default value: $::harmony::params::https_port

##### `sftp_port`

Data type: `Integer`



Default value: $::harmony::params::sftp_port

##### `import_file`

Data type: `String`



Default value: $::harmony::params::import_file

##### `import_password`

Data type: `String`



Default value: $::harmony::params::import_password

##### `cert_password`

Data type: `String`



Default value: $::harmony::params::cert_password

##### `do_initial_config`

Data type: `Boolean`



Default value: $::harmony::params::do_initial_config

##### `patch_file_name`

Data type: `String`



Default value: "${patch_no}.zip"

##### `installer_cache`

Data type: `String`



Default value: "/vagrant/installers/${installer_name}"

##### `dashboard_cache`

Data type: `String`



Default value: "/vagrant/installers/${::harmony::params::dashboard_installer}"

##### `patch_cache`

Data type: `String`



Default value: "/vagrant/${patch_file_name}"

##### `s3_cache`

Data type: `String`



Default value: "${::harmony::params::s3_bucket}/${installer_name}"

##### `s3_dashboard_cache`

Data type: `String`



Default value: "${::harmony::params::s3_bucket}/${::harmony::params::dashboard_installer}"

##### `s3_patch_cache`

Data type: `String`



Default value: "${::harmony::params::s3_bucket}/${patch_file_name}"

##### `patch_download_url`

Data type: `String`



Default value: "http://www.cleo.com/Web_Install/PatchBase_${::harmony::params::patch_base}/harmony/${patch_no}/${patch_file_name}"

##### `cluster`

Data type: `Boolean`



Default value: $::harmony::params::cluster

##### `cluster_ip`

Data type: `String`



Default value: $::harmony::params::cluster_ip

##### `cluster_license`

Data type: `String`



Default value: $::harmony::params::cluster_license


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


### harmony::params

harmony::params

Paramater defaults for the harmony class

#### Examples
##### basic usage
```puppet
Not used directly, but part of the Harmony module
```


### harmony::service

The harmony::service class.


