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
    release    => 'wheezy-php55',
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

define php_supporting () {
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

define php_main ($version) {
  include augeas
  include php
  include php::pear

  class {
    'php::dev':
      ensure => $version;
    'php::extension::imagick':
      ensure => $version;
    'php::extension::mcrypt':
      ensure => $version;
    'php::extension::mysql':
      ensure => $version;
    'php::extension::redis':
      ensure => $version;
    'php::fpm': 
      ensure => $version;
    'php::composer': ;
  }
}

class php_install {
  Php_supporting <| |> -> Php_main <| |>

  php_supporting { "supporting": }
  
  php_main { "php-5.5.0":
    version => "5.5.0-1~dotdeb.1",
  }
}

class mail_configuration {
  package { ["postfix", "dovecot-core"]: }
}

class cache_configuration {
  class { 'redis':
    version => '2.6.14',
  }

  class { 'memcached':
    max_memory => '12%',
    install_dev => true,
  }
}

# Include classes

class { 'debian_update':
  stage => preinstall
}

include git
include php_install
include mail_configuration, cache_configuration
include rabbitmq::server
include java, elasticsearch
include nginx

class { 'mysql::server':
  config_hash => { 'root_password' => 'password' }
}