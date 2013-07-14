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

class php-main {
  include php
  include php::apt

  class { "php::cli": ensure => '5.4.17-1~dotdeb.0' }
}

class php-supporting {
  package { "ntp": }
  package { "imagemagick": }
  package { "subversion": }
  package { "nasm": }
  package { "yasm": }
  package { "autoconf": }
  package { "tidy": }
  package { "libtidy-dev": }
  package { "curl": }
  package { "libcurl4-openssl-dev": }
  package { "libxml++2.6-dev": }
  package { "mcrypt": }
  package { "libmcrypt-dev": }
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

Class['php-supporting'] -> Class['php-main']