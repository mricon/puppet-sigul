class sigul::bridge::install inherits sigul::bridge {
  if $::sigul::bridge::manage_package {
    package { $::sigul::bridge::package_name:
      ensure => present,
    }
  }
}
