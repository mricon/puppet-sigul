define sigul::client::instance (
  Enum['present','absent'] $ensure              = 'present',

  String                   $client_user         = $::sigul::user,
  String                   $client_group        = $::sigul::group,

  Pattern['^\/']           $config_file         = "${::sigul::conf_dir}/client-${name}.conf",
  String                   $config_file_seltype = $::sigul::conf_dir_seltype,

  # [client] section
  String               $bridge_hostname         = 'localhost',
  Integer[1025,65535]  $bridge_port             = 44334,
  String               $client_cert_nickname    = 'sigul-client-cert',
  String               $server_hostname         = 'localhost',
  Optional[String]     $user_name               = 'nobody',

  # [koji] section
  Optional[String]     $koji_config             = undef,
  # koji_instances must be a hash in the following format:
  # ppc64:
  #   config: '~/.koji-ppc64.conf'
  #   fas_group: 'ppc64-signers'
  # s390:
  #   config: '~/.koji-s390.conf'
  #   fas_group: 's390-signers'
  Optional[Hash]       $koji_instances          = undef,

  # [nss] section
  Pattern['^\/']       $nss_dir                 = $::sigul::nss_dir,
  Optional[String]     $nss_password            = $::sigul::nss_password,
  String               $nss_min_tls             = 'tls1.2',
  String               $nss_max_tls             = 'tls1.2',

  # [binding] section
  Optional[Array]      $binding_enabled         = undef,
) {
  contain ::sigul::install

  file { $config_file:
    ensure    => $ensure,
    owner     => $client_user,
    group     => $client_group,
    mode      => '0600',
    seltype   => $config_file_seltype,
    content   => template('sigul/client.conf.erb'),
    show_diff => false,
    require   => Class['sigul::install'],
  }
}
