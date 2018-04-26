
# harmony

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with harmony](#setup)
    * [What harmony affects](#what-harmony-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with harmony](#beginning-with-harmony)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

The Harmony module installs Cleo Harmony.

Cleo Harmony is a multi-protocol file transfer gateway, which supports automation, clustering, common visiblity and too many other features to mention.

## Setup

### What harmony affects **OPTIONAL**

* Packages, services and configuration files for Harmony
* Listened-to ports
* May also install postgres database if option is selected

### Setup Requirements **OPTIONAL**

### Beginning with harmony  

To configure a basic default Harmony install, declare the harmony class.

```puppet
class {'harmony':
}
```

## Usage

### Basic installation

For default settings, declare the harmony as defined above. To customize the settings, specify the parameters you want to change:

```puppet
class { 'harmony':
    user => "harmony",
    group => "harmony",
    manage_user => true,
    install_dir => "/home/harmony",
    manage_database => true,
    database_type => 'postgres',
    database_name => 'postgres',
    database_user => 'postgres',
    database_password => 'postgres',
    do_initial_config => true,
    patch_no => '',
    import_file => '/vagrant/Harmony6346037748152906426.zip',
    import_password => 'cleocleo',
    cert_password => 'cleocleo',
}
```

## Reference

### Classes

#### harmony

Installs and configures harmony

#### `user`

The Linux user under which the Harmony install should take place

#### `manage_user`

Whether to create the user under which Harmony will be installed

Valid values: 'true', 'false'.
Default value: 'false'

#### `group`

The Linux group to create into which the created user will be put (if manage_user is set to true)

## Limitations

## Development

## Release Notes/Contributors/Etc. **Optional**

