class sigul::server (
  Boolean                   $manage_package = $::sigul::server::params::manage_package,
  String                    $package_name   = $::sigul::server::params::package_name,

  Boolean                   $manage_service = $::sigul::server::params::manage_service,
  String                    $service_name   = $::sigul::server::params::service_name,
  Enum['running','stopped'] $service_ensure = $::sigul::server::params::service_ensure,
  Boolean                   $service_enable = $::sigul::server::params::service_enable,

  Pattern['^\/']            $config_file    = $::sigul::server::params::config_file,

) inherits sigul::server::params {

  anchor { 'sigul::server::begin': }
  ->class { '::sigul::server::install': }
  ->class { '::sigul::server::config': }
  ->class { '::sigul::server::service': }
  ->anchor { 'sigul::server::end': }
}
