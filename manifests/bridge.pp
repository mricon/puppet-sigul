class sigul::bridge (
  Boolean                   $manage_package = $::sigul::bridge::params::manage_package,
  String                    $package_name   = $::sigul::bridge::params::package_name,

  Boolean                   $manage_service = $::sigul::bridge::params::manage_service,
  String                    $service_name   = $::sigul::bridge::params::service_name,
  Enum['running','stopped'] $service_ensure = $::sigul::bridge::params::service_ensure,
  Boolean                   $service_enable = $::sigul::bridge::params::service_enable,

  Pattern['^\/']            $config_file    = $::sigul::bridge::params::config_file,

) inherits sigul::bridge::params {

  anchor { 'sigul::bridge::begin': }
  ->class { '::sigul::bridge::install': }
  ->class { '::sigul::bridge::config': }
  ->class { '::sigul::bridge::service': }
  ->anchor { 'sigul::bridge::end': }
}
