# Configure Exec

Exec {
  path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}

# Stages

stage { 'preinstall':
  before => Stage['main']
}

# Custom classes

class debian-update {
  exec { "apt-get update":
    command => "apt-get update",
  }

  exec { "apt-get upgrade":
    command => "apt-get -y dist-upgrade",
    require => Exec["apt-get update"],
  }
}

class php-configuration {
  file { 'php.ini':
    path    => '/tmp/php.ini.bak',
    ensure  => present,
    mode    => 0755,
    content => 'a value'
  }
}

class php-supporting {
  package { "ntp": }
  package { "imagemagick": }
}

class mail-configuration {
  package { "postfix": }
  package { "dovecot-core": }
}

class cache-configuration {
  class { 'redis': version => '2.6.14', }
  class { 'memcached': max_memory => '12%', }
}

# Include classes

class { 'debian-update':
  stage => preinstall
}

class { 'apt': }
class { 'git': }
class { 'php-configuration': }
class { 'php-supporting': }
class { 'mail-configuration': }
class { 'cache-configuration': }
class { 'rabbitmq::server': }
class { 'java': }
class { 'elasticsearch': }
class { 'mysql::server':
  config_hash => { 'root_password' => 'password' }
}
class { 'nginx': }