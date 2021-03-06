class sigul::params {
  $manage_package = true
  $package_name = 'sigul'

  # put nss into where it should be, /etc/pki
  $manage_nss_dir = true
  $nss_dir = '/etc/pki/sigul'
  $nss_dir_seltype = 'cert_t'
  $nss_password = undef

  # usually created by the package
  $manage_var_dir = false
  $var_dir = '/var/lib/sigul'
  $var_dir_seltype = 'sigul_var_lib_t'

  # usually created by the package
  $manage_conf_dir = false
  $conf_dir = '/etc/sigul'
  $conf_dir_seltype = 'sigul_conf_t'

  # usually created by the package
  $manage_user  = false
  $user         = 'sigul'
  $user_uid     = undef
  $manage_group = false
  $group        = 'sigul'
  $group_gid    = undef
}
