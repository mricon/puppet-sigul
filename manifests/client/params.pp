class sigul::client::params {
  include ::sigul

  $client_user         = $::sigul::user
  $client_group        = $::sigul::group
  $config_file_seltype = $::sigul::conf_dir_seltype
  $config_file         = "${::sigul::conf_dir}/client.conf"
  $config              = {}
  $instances           = undef
}
