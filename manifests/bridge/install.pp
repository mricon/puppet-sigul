class sigul::bridge::install {
  if $::sigul::bridge::manage_package {
    package { $::sigul::bridge::package_name:
      ensure => present,
    }
  }
}
