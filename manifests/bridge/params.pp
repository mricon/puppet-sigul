class sigul::bridge::params {
  include ::sigul

  $manage_package = true
  $package_name   = 'sigul-bridge'

  $manage_service = true
  $service_name   = 'sigul_bridge'
  $service_ensure = 'running'
  $service_enable = true

  $config_file = "${::sigul::conf_dir}/bridge.conf"
  $config      = {}
}
