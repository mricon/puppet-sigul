class sigul::client::config (
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
  Pattern['^\/']       $nss_dir                 = "${::sigul::var_dir}/nss",
  Optional[String]     $nss_password            = undef,
  String               $nss_min_tls             = 'tls1.2',
  String               $nss_max_tls             = 'tls1.2',

  # [binding] section
  Optional[Array]      $binding_enabled         = undef,

  # Location of the config file
  Pattern['^\/']       $config_file             = $::sigul::client::config_file,

) inherits sigul::client {
  file { $config_file:
    ensure    => present,
    owner     => $::sigul::client::client_user,
    group     => $::sigul::client::client_group,
    mode      => '0600',
    seltype   => $::sigul::client::conf_file_seltype,
    content   => template('sigul/client.conf.erb'),
    show_diff => false,
  }
}
