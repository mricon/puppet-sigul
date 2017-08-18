class sigul::client (
  String         $client_user         = $::sigul::client::params::client_user,
  String         $client_group        = $::sigul::client::params::client_group,
  String         $config_file_seltype = $::sigul::client::params::config_file_seltype,

  Pattern['^\/'] $config_file         = $::sigul::client::params::config_file,
  Hash           $config              = $::sigul::client::params::config,

  Optional[Hash] $instances           = $::sigul::client::params::instances,

) inherits sigul::client::params {
  contain ::sigul

  if is_hash($instances) {
    $ensure_default_instance = 'absent'
    $instances.each |$resource, $options| {
      sigul::client::instance { $resource:
        * => $options,
      }
    }
  } else {
    $ensure_default_instance = 'present'
  }

  sigul::client::instance { '__default__':
    ensure              => $ensure_default_instance,
    client_user         => $client_user,
    client_group        => $client_group,
    config_file_seltype => $config_file_seltype,
    config_file         => $config_file,
    *                   => $config,
  }
}
