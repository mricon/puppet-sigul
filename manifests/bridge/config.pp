class sigul::bridge::config (
  # [bridge] section
  String              $bridge_cert_nickname     = 'sigul-bridge-cert',
  Integer[1025,65535] $client_listen_port       = 44334,
  Integer[1025,65535] $server_listen_port       = 44333,

  Optional[String]     $required_fas_group      = undef,
  Optional[String]     $fas_user_name           = undef,
  Optional[String]     $fas_password            = undef,

  Optional[Integer]    $max_rpms_payload_size   = undef,

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

  # [daemon] section
  String               $unix_user               = $::sigul::user,
  String               $unix_group              = $::sigul::group,

  # [nss] section
  Pattern['^\/']       $nss_dir                 = "${::sigul::var_dir}/nss",
  Optional[String]     $nss_password            = undef,
  String               $nss_min_tls             = 'tls1.2',
  String               $nss_max_tls             = 'tls1.2',

) inherits sigul::bridge {
  file { $::sigul::bridge::config_file:
    ensure    => present,
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    seltype   => $::sigul::conf_dir_seltype,
    content   => template('sigul/bridge.conf.erb'),
    show_diff => false,
  }
}
