class sigul (
  Boolean           $manage_package   = $::sigul::params::manage_package,
  String            $package_name     = $::sigul::params::package_name,

  Boolean           $manage_var_dir   = $::sigul::params::manage_var_dir,
  Pattern['^\/']    $var_dir          = $::sigul::params::var_dir,
  String            $var_dir_seltype  = $::sigul::params::var_dir_seltype,

  Boolean           $manage_conf_dir  = $::sigul::params::manage_conf_dir,
  Pattern['^\/']    $conf_dir         = $::sigul::params::conf_dir,
  String            $conf_dir_seltype = $::sigul::params::conf_dir_seltype,

  Boolean           $manage_user      = $::sigul::params::manage_user,
  String            $user             = $::sigul::params::user,
  Optional[Integer] $user_uid         = $::sigul::params::user_uid,

  Boolean           $manage_group     = $::sigul::params::manage_group,
  String            $group            = $::sigul::params::group,
  Optional[Integer] $group_gid        = $::sigul::params::group_gid,

) inherits sigul::params {

  anchor { 'sigul::begin': }
  ->class { '::sigul::install': }
  ->anchor{ 'sigul::end': }

}
