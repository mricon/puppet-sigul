class sigul::server::params {
  include ::sigul

  $manage_package = true
  $package_name   = 'sigul-server'

  $manage_service = true
  $service_name   = 'sigul_server'
  $service_ensure = 'running'
  $service_enable = true

  $create_db      = true
  $create_db_cmd  = '/sbin/sigul_server_create_db'

  $config_file = "${::sigul::conf_dir}/server.conf"
}
