class sigul::client (
  String         $client_user       = $::sigul::client::params::client_user,
  String         $client_group      = $::sigul::client::params::client_group,
  String         $conf_file_seltype = $::sigul::client::params::conf_file_seltype,

  Pattern['^\/'] $config_file       = $::sigul::client::params::config_file,

) inherits sigul::client::params {

  anchor { 'sigul::client::begin': }
  ->class { '::sigul::client::config': }
  ->anchor { 'sigul::client::end': }
}
