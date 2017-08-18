define sigul::server::instance (
  Enum['present','absent']  $ensure         = 'present',

  Boolean                   $manage_log_dir = true,
  Pattern['^\/']            $log_dir        = "/var/log/sigul-${name}",
  Boolean                   $manage_pid_dir = true,
  Pattern['^\/']            $pid_dir        = "/run/sigul-${name}",
  Boolean                   $create_db      = false,

  String                    $service_name   = "sigul_server@${name}",
  Enum['running','stopped'] $service_ensure = 'running',
  Boolean                   $service_enable = true,

  Pattern['^\/']            $config_file    = "${::sigul::conf_dir}/server-${name}.conf",

  # [server] section
  String               $bridge_hostname         = 'localhost',
  Integer[1025,65535]  $bridge_port             = 44433,
  Integer              $max_file_payload_size   = 1073741824,
  Integer              $max_memory_payload_size = 1048576,
  Integer              $max_rpms_payload_size   = 10737418240,
  # By default, instances share the cert
  String               $server_cert_nickname    = 'sigul-server-cert',
  Integer[0]           $signing_timeout         = 60,
  Optional[Boolean]    $lenient_username_check  = undef,
  Optional[Array]      $proxy_usernames         = undef,

  # [database] section
  # By default, instances share the same user db
  Pattern['^\/']       $database_path           = "${::sigul::var_dir}/server.sqlite",

  # [gnupg] section
  # By default, instances use the same gnupg homedir
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
  # By default, instances use the same nss directory
  Pattern['^\/']       $nss_dir                 = $::sigul::nss_dir,
  Optional[String]     $nss_password            = $::sigul::nss_password,
  String               $nss_min_tls             = 'tls1.2',
  String               $nss_max_tls             = 'tls1.2',

  # [binding] section
  Optional[Array]      $binding_enabled         = undef,

) {
  contain ::sigul::install
  contain ::sigul::server::params
  contain ::sigul::server::install

  file { $config_file:
    ensure    => $ensure,
    owner     => $unix_user,
    group     => $unix_group,
    mode      => '0600',
    seltype   => $::sigul::conf_dir_seltype,
    content   => template('sigul/server.conf.erb'),
    show_diff => false,
    require   => Class['sigul::install'],
  }

  if $manage_pid_dir {
    file { "/etc/tmpfiles.d/sigul-server-${name}.conf":
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "d ${pid_dir} 0755 root root\n",
      before  => Service[$service_name],
    }
  }

  if $ensure == 'present' {
    if $create_db {
      exec { "sigul-server-create-db-${name}":
        command => "${::sigul::server::params::create_db_cmd} -c ${config_file}",
        creates => $database_path,
        user    => $unix_user,
        require => File[$config_file],
      }
    }

    if $manage_log_dir {
      file { $log_dir:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0700',
        before => Service[$service_name],
      }
    }

    if $manage_pid_dir {
      file { $pid_dir:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        before => Service[$service_name],
      }
    }

    $real_service_ensure = $service_ensure
    $real_service_enable = $service_enable

  } else {
    $real_service_ensure = 'stopped'
    $real_service_enable = false
  }

  service { $service_name:
    ensure     => $real_service_ensure,
    enable     => $real_service_enable,
    hasstatus  => true,
    hasrestart => true,
    require    => File[$config_file],
    subscribe  => File[$config_file],
  }
}
