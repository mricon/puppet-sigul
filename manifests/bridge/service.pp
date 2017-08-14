class sigul::bridge::service inherits sigul::bridge {
  if $::sigul::bridge::manage_service {
    service { $::sigul::bridge::service_name:
      ensure     => $::sigul::bridge::service_ensure,
      enable     => $::sigul::bridge::service_enable,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => File[$::sigul::bridge::config_file],
    }
  }
}
