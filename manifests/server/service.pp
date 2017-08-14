class sigul::server::service inherits sigul::server {
  if $::sigul::server::manage_service {
    service { $::sigul::server::service_name:
      ensure     => $::sigul::server::service_ensure,
      enable     => $::sigul::server::service_enable,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => File[$::sigul::server::config_file],
    }
  }
}
