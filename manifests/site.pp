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

define php_main () {
  include augeas
  include php
  include php::dev
  include php::pear
  include php::fpm
  include php::composer
  include php::extension::imagick
  include php::extension::mcrypt
  include php::extension::mysql
  include php::extension::redis

  php::extension { 'memcached':
    ensure   => installed,
    provider => pecl,
    package  => "pecl.php.net/memcached",
  }

  php::config { 'memcached':
      inifile  => '/etc/php5/conf.d/memcached.ini',
      settings => {
        set => {
            '.anon/extension' => 'memcached.so',
        }
      },
      notify => Class['php::fpm']
  }

  php::extension { 'jsmin':
    ensure   => installed,
    provider => pecl,
    package  => "pecl.php.net/jsmin-beta",
  }

  php::config { 'jsmin':
      inifile  => '/etc/php5/conf.d/jsmin.ini',
      settings => {
        set => {
            '.anon/extension' => 'jsmin.so',
        }
      },
      notify => Class['php::fpm']
  }

  Class['php::dev'] -> Class['php::pear'] -> Php::Extension <| |> -> Php::Config <| |>
}

class php_install {
  php_supporting { "supporting": }
  php_main { "php-5.5.0": }

  Php_supporting <| |> -> Php_main <| |>
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

  Class['redis'] -> Class['php::extension::redis']
}

# Include classes

class { 'sqmk::apt::repo':
  stage => preinstall
}

include git
include php_install
include mail_configuration, cache_configuration
include rabbitmq::server
include java, elasticsearch

class { 'nginx':
  confd_purge => true
}

nginx::resource::vhost { 'php-dev.example.com':
  ensure   => present,
  www_root => '/vagrant/app/www',
}

nginx::resource::location { 'php-dev.example.com:php':
  ensure         => present,
  vhost          => 'php-dev.example.com',
  www_root       => '/vagrant/app/www',
  location       => '~ \.php$',
  fastcgi        => 'unix:/var/run/php5-fpm.sock',
  fastcgi_script => '$document_root$fastcgi_script_name',
}

class { 'mysql::server':
  config_hash => { 'root_password' => 'password' }
}