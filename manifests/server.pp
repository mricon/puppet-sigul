class sigul::server (
  Boolean                   $manage_package = $::sigul::server::params::manage_package,
  String                    $package_name   = $::sigul::server::params::package_name,

  Boolean                   $manage_log_dir = $::sigul::server::params::manage_log_dir,
  Pattern['^\/']            $log_dir        = $::sigul::server::params::log_dir,
  Boolean                   $manage_pid_dir = $::sigul::server::params::manage_pid_dir,
  Pattern['^\/']            $pid_dir        = $::sigul::server::params::pid_dir,

  Boolean                   $create_db      = $::sigul::server::params::create_db,
  Pattern['^\/']            $create_db_cmd  = $::sigul::server::params::create_db_cmd,

  String                    $service_name   = $::sigul::server::params::service_name,
  Enum['running','stopped'] $service_ensure = $::sigul::server::params::service_ensure,
  Boolean                   $service_enable = $::sigul::server::params::service_enable,

  Pattern['^\/']            $config_file    = $::sigul::server::params::config_file,
  Hash                      $config         = $::sigul::server::params::config,

  Optional[Hash]            $instances      = $::sigul::server::params::instances,

) inherits sigul::server::params {

  contain ::sigul

  if is_hash($instances) {
    $ensure_default_instance = 'absent'

    $instances.each |$resource, $options| {
      sigul::server::instance { $resource:
        * => $options,
      }
    }
  } else {
    $ensure_default_instance = 'present'
  }

  sigul::server::instance { '__default__':
    ensure         => $ensure_default_instance,
    manage_log_dir => $manage_log_dir,
    log_dir        => $log_dir,
    manage_pid_dir => $manage_pid_dir,
    pid_dir        => $pid_dir,
    create_db      => $create_db,
    service_name   => $service_name,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    config_file    => $config_file,
    *              => $config,
  }
}
