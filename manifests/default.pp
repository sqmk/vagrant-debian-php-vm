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
  class { 'apt': }

  apt::source { 'dotdeb':
    location   => 'http://packages.dotdeb.org',
    release    => 'wheezy',
    repos      => 'all',
    key        => '89DF5277',
    key_server => 'keys.gnupg.net'
  }

  exec { "apt-get update":
    command => "apt-get update",
    require => Apt::Source['dotdeb'],
  }

  exec { "apt-get upgrade":
    command => "apt-get -y dist-upgrade",
    require => Exec["apt-get update"],
  }
}

class php-main {
  include php
  include php::pear

  class { 'php::composer': }
  class { 'php::extension::mcrypt': }
  class { 'php::extension::mysql': }
  class { 'php::fpm': }
}

class php-supporting {
  package {
    [
      "ntp",
      "imagemagick",
      "subversion",
      "nasm",
      "yasm",
      "autoconf",
      "tidy",
      "libtidy-dev",
      "curl",
      "libcurl4-openssl-dev",
      "libxml++2.6-dev",
      "mcrypt",
      "libmcrypt-dev"
    ]:
  }
}

class mail-configuration {
  package { ["postfix", "dovecot-core"]: }
}

class cache-configuration {
  class { 'redis': version => '2.6.14', }
  class { 'memcached': max_memory => '12%', }
}

# Include classes

class { 'debian-update':
  stage => preinstall
}

class { 'git': }
class { 'php-main': }
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