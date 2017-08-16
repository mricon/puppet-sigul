# Sigul

[![Build Status](https://travis-ci.org/mricon/puppet-sigul.svg?branch=master)]
(https://travis-ci.org/mricon/puppet-sigul)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup](#setup)
4. [Reference](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview
Puppet module to manage sigul secure signing server infrastructure setup,
including server, bridge and client configurations.

## Module Description
Sigul is a multi-tier implementation of a service that would offer a secure
mechanism for automated PGP-signing of binary and other artifacts without
exposing the PGP keys themselves to untrusted processes (for example, during
automated builds).

See https://pagure.io/sigul for more info about Sigul.

This module was forked from https://github.com/jflorian/puppet-sigul and
pretty much fully rewritten from scratch while preserving some of the existing
logic.

Some of the previous functionality was removed and may be added later as
optional functionality:

  - firewall management (best to use profile modules for that)
  - certificate management (best to use profile modules for that)
  - gnupg1 kludges (the upcoming version of sigul should work with gnupg2)

## Setup
It's expected that this module will be used with hiera, so the quickest way to
configure it for your environment is to add it to your Puppetfile:

```
mod 'mricon-sigul'
```

### NSS database/certificate management
Please note that while NSS certificate management is a critical aspect of
sigul operation, this module does NOT attempt to manage NSS, because there are
too many possible ways of doing that (e.g. via certutil directly, or via
certmonger+freeipa integration). You will need to decide how you are going to
do that as part of your sigul deployment and use your profile manifests to
properly set it up.

All three subcomponents of sigul (server, bridge, client) allow specifying the
location of the NSS directory and the password:

```yaml
# The following needs to correspond to the location and password
# you used when setting up your nss certificate store. The value for
# nss_password can be set to '' if there is no password on the store
# (e.g. if it is automatically managed by certmonger).
sigul::server::config::nss_dir: '/etc/pki/sigul'
sigul::server::config::nss_password: 'somepass'
```

### Firewall management
The same limitation goes for opening firewall ports, since it can either be
done via the puppetlabs firewall module or via shorewall. You should be able
to find out the ports that you will need to open via corresponding
$::sigul::server::config::* or $::sigul::bridge::config::* variables.

## Reference
### sigul

#### `manage_package`

Whether to manage the sigul package. See note at the end on where to get the
packages for CentOS7 systems.

Default: `true`

#### `package_name`

Package name (OS-specific).

Default: `sigul`

#### `manage_var_dir`

Whether to create the var dir. Off by default because this is normally done
by packages themselves.

Default: `false`

#### `var_dir`

Where persistent data is going to be stored.

Default: `/var/lib/sigul`

#### `var_dir_seltype`

What SELinux type should be on the vardir. Note that only recent versions of
sigul packages install their own SELinux policy, so if you are getting errors
due to the default settings here, change it to `var_lib_t`.

Default: `sigul_var_lib_t`

#### `manage_conf_dir`

Whether to create the configuration dir. Off by default because this is
normally done by packages themselves.

Default: `false`

#### `conf_dir`

The location of config files. You can override specific configuration file
locations for server, bridge, and client in their own module declarations.

Default: `/etc/sigul`

#### `conf_dir_seltype`

What SELinux type should be on the config file dir. Note that only recent
versions of sigul packages install their own SELinux policy, so if you are
getting errors due to the default settings here, change it to `etc_t`.

Default: `sigul_conf_t`

#### `manage_user`

Whether to create the user record. Off by default, because usually done by the
package.

Default: `false`

#### `user`

What users should the daemons run as. Also sets ownership of all writable and
readable locations.

Default: `sigul`

#### `user_uid`

If you want to force the UID to a specific numeric value, do it here.

Default: `undef`

#### `manage_group`

Whether to create the group record. Off by default, because usually done by the
package.

Default: `false`

#### `group`

What group should various files be owned as.

Default: `sigul`

#### `group_gid`

You can force the sigul group to be a specific gid.

Default: `undef`

### sigul::server

#### `manage_package`

Default: `true`

#### `package_name`

Default: `sigul-server`

#### `manage_service`

Default: `true`

#### `service_name`

Default: `sigul_server`

#### `service_ensure`

Default: `running`

#### `service_enable`

Default: `true`

#### `create_db`

Whether to create the sigul sqlite3 db if it is not found in the specified
location.

Default: `true`

#### `create_db_cmd`

Default: `/sbin/sigul_server_create_db`

#### `config_file`

Default: `$::sigul::conf_dir/server.conf`

### sigul::server::config

Refer to manifests/server/config.pp to see all available configuration
options and default values. Generally, they correspond to the config file
variables, except with underscores instead of dashes. E.g.:

bridge-hostname = $::sigul::server::config::bridge_hostname.

### sigul::bridge

#### `manage_package`

Default: `true`

#### `package_name`

Default: `sigul-bridge`

#### `manage_service`

Default: `true`

#### `service_name`

Default: `sigul_bridge`

#### `service_ensure`

Default: `running`

#### `service_enable`

Default: `true`

#### `config_file`

Default: `$::sigul::conf_dir/bridge.conf`

### sigul::bridge::config

Refer to manifests/bridge/config.pp to see all available configuration
options and default values. Generally, they correspond to the config file
variables, except with underscores instead of dashes. E.g.:

bridge-cert-nickname = $::sigul::bridge::config::bridge_cert_nickname

### sigul::client

#### `client_user`

If you're running client and bridge on the same system, you may want to run
them as different users. This lets you override the toplevel sigul::user
configuration.

Default: `$::sigul::user`

#### `client_group`

Default: `$::sigul::group`

#### `conf_file_seltype`

In case you're storing the config file somewhere other than the global
/etc/sigul directory, you can override the seltype here.

Default: `$::sigul::conf_dir_seltype`

#### `config_file`

Default: `$::sigul::conf_dir/client.conf`

### sigul::client::config

Refer to manifests/client/config.pp to see all available configuration
options and default values. Generally, they correspond to the config file
variables, except with underscores instead of dashes. E.g.:

bridge-hostname = $::sigul::bridge::config::bridge_hostname

## Limitations
The module was written for CentOS7 but should work on other architectures
with minimal changes.

For CentOS7 packages of sigul, you can use the repositories published by
Fedora-Infrastructure. Here are the example entries to add to your profile
manifests:

```
# Grab sigul packages from this Fedora infra repo
yumrepo {'fedora-infra-sigul':
  descr       => 'Fedora-Infrastructure packages for sigul',
  baseurl     => 'https://infrastructure.fedoraproject.org/repo/infra/epel$releasever-infra/$basearch/',
  gpgkey      => 'https://infrastructure.fedoraproject.org/repo/infra/RPM-GPG-KEY-INFRA-TAGS',
  enabled     => 1,
  gpgcheck    => 1,
  includepkgs => 'sigul*',
}
```

Until sigul works with gnupg2, you will need the gnupg1 package as well, but
only for sigul::server. Note that it's a different repository from above.

```
yumrepo {'fedora-infra-gnupg1':
  descr       => 'Fedora-Infrastructrure packages for gnupg1',
  baseurl     => 'https://infrastructure.fedoraproject.org/repo/$releasever/$basearch/',
  gpgkey      => 'https://infrastructure.fedoraproject.org/repo/RPM-GPG-KEY-INFRASTRUCTURE',
  enabled     => 1,
  gpgcheck    => 1,
  includepkgs => 'gnupg1*',
}
```
