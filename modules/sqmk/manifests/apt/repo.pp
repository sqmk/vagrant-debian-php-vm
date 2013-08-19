# == Class: sqmk::apt::repo
#
# Manages additional repos.
#
# === Parameters
#
# No parameters
#
class sqmk::apt::repo {
	include apt
	include apt::update

	anchor { 'sqmk::apt::repo::begin':
		before => Apt::Source['dotdeb'],
	}

  apt::source { 'dotdeb':
    location   => 'http://packages.dotdeb.org',
    release    => 'wheezy-php55',
    repos      => 'all',
    key        => '89DF5277',
    key_server => 'keys.gnupg.net',
  }

  apt::source { '10gen':
    location    => 'http://downloads-distro.mongodb.org/repo/debian-sysvinit',
    release     => 'dist',
    repos       => '10gen',
    key         => '7F0CEB10',
    key_server  => 'keyserver.ubuntu.com',
    include_src => false,
  }

  exec { 'apt-get upgrade':
    command => "apt-get -y dist-upgrade",
    require => Class['apt::update'],
  }

  anchor { 'sqmk::apt::repo::end':
  	require => Exec['apt-get upgrade']
	}
}
