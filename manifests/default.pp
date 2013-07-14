# Configure Exec

Exec {
  path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}

# Stages

stage { 'preinstall':
  before => Stage['main']
}

# Custom classes

class debian_update {
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

class php_main {
  include augeas
  include php
  include php::pear

  class { 'php::composer': }
  class { 'php::extension::mcrypt': }
  class { 'php::extension::mysql': }
  class { 'php::fpm': }
}

class php_supporting {
  Class['php_supporting'] -> Class['php_main']

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

class mail_configuration {
  package { ["postfix", "dovecot-core"]: }
}

class cache_configuration {
  class { 'redis': version => '2.6.14', }
  class { 'memcached': max_memory => '12%', }
}

# Include classes

class { 'debian_update':
  stage => preinstall
}

include git, php_supporting, php_main
include php_supporting, php_main
include mail_configuration, cache_configuration
include rabbitmq::server
include java, elasticsearch
include nginx

class { 'mysql::server':
  config_hash => { 'root_password' => 'password' }
}