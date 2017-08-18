class sigul::install {
  contain ::sigul

  if $::sigul::manage_package {
    package { $::sigul::package_name:
      ensure => present,
    }
  }

  if $::sigul::manage_user {
    user { $::sigul::user:
      ensure     => present,
      home       => $::sigul::var_dir,
      shell      => '/sbin/nologin',
      uid        => $::sigul::user_uid,
      managehome => false,
      password   => '!!',
      gid        => $::sigul::group,
    }
  }

  if $::sigul::manage_group {
    group { $::sigul::group:
      ensure => present,
      gid    => $::sigul::group_gid,
    }
  }

  if $::sigul::manage_nss_dir {
    file { $::sigul::nss_dir:
      ensure  => directory,
      mode    => '0700',
      owner   => $::sigul::user,
      group   => $::sigul::group,
      seltype => $::sigul::nss_dir_seltype,
    }
  }
  if $::sigul::manage_var_dir {
    file { $::sigul::var_dir:
      ensure  => directory,
      mode    => '0700',
      owner   => $::sigul::user,
      group   => $::sigul::group,
      seltype => $::sigul::var_dir_seltype,
    }
  }
  if $::sigul::manage_conf_dir {
    file { $::sigul::conf_dir:
      ensure  => directory,
      mode    => '0700',
      owner   => 'root',
      group   => 'root',
      seltype => $::sigul::conf_dir_seltype,
    }
  }
  file { '/etc/logrotate.d/sigul':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/sigul.logrotate",
  }
}
