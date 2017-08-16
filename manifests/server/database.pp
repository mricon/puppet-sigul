class sigul::server::database inherits sigul::server {
  if $::sigul::server::create_db {
    exec { 'sigul_server_create_db':
      command => $::sigul::server::create_db_cmd,
      creates => $::sigul::server::config::database_path,
      user    => $::sigul::server::config::unix_user,
    }
  }
}
