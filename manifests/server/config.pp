class sigul::server::config (
  # [server] section
  String               $bridge_hostname         = 'localhost',
  Integer[1025,65535]  $bridge_port             = 44333,
  Integer              $max_file_payload_size   = 1073741824,
  Integer              $max_memory_payload_size = 1048576,
  Integer              $max_rpms_payload_size   = 10737418240,
  String               $server_cert_nickname    = 'sigul-server-cert',
  Integer[0]           $signing_timeout         = 60,
  Optional[Boolean]    $lenient_username_check  = undef,
  Optional[Array]      $proxy_usernames         = undef,

  # [database] section
  Pattern['^\/']       $database_path           = "${::sigul::var_dir}/server.sqlite",

  # [gnupg] section
  Pattern['^\/']       $gnupg_home              = "${::sigul::var_dir}/gnupg",
  Enum['DSA','RSA']    $gnupg_key_type          = 'RSA',
  Integer[1024,4096]   $gnupg_key_length        = 2048,
  Optional[Enum['DSA','RSA','ELG-E']]
    $gnupg_subkey_type                          = undef,
  Optional[Integer]    $gnupg_subkey_length     = undef,
  String               $gnupg_key_usage         = 'sign',
  Integer[64]          $passphrase_length       = 64,

  # [daemon] section
  String               $unix_user               = $::sigul::user,
  String               $unix_group              = $::sigul::group,

  # [nss] section
  Pattern['^\/']       $nss_dir                 = "${::sigul::var_dir}/nss",
  Optional[String]     $nss_password            = undef,
  String               $nss_min_tls             = 'tls1.2',
  String               $nss_max_tls             = 'tls1.2',

  # [binding] section
  Optional[Array]      $binding_enabled         = undef,

) inherits sigul::server {
  file { $::sigul::server::config_file:
    ensure    => present,
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    seltype   => $::sigul::conf_dir_seltype,
    content   => template('sigul/server.conf.erb'),
    show_diff => false,
  }
}
