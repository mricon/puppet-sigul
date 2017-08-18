class sigul::server::install {
  # install the template systemd service file
  file { '/usr/lib/systemd/system/sigul_server@.service':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/sigul_server@.service",
  }

  if $::sigul::server::manage_package {
    package { $::sigul::server::package_name:
      ensure => present,
    }
  }
}
