class sigul::server::install inherits sigul::server {
  if $::sigul::server::manage_package {
    package { $::sigul::server::package_name:
      ensure => present,
    }
  }
}
