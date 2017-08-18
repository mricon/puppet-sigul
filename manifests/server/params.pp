class sigul::server::params {
  contain ::sigul

  $manage_package      = true
  $package_name        = 'sigul-server'

  $create_db_cmd       = '/sbin/sigul_server_create_db'

  $manage_log_dir      = false
  $log_dir             = '/var/log'
  $manage_pid_dir      = false
  $pid_dir             = '/run'
  $create_db           = true

  $service_name        = 'sigul_server'
  $service_ensure      = 'running'
  $service_enable      = true

  $instances           = undef
  $config_file         = "${::sigul::conf_dir}/server.conf"
  $config              = {}
}
