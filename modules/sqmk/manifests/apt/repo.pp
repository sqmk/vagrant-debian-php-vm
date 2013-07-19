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

  exec { 'apt-get upgrade':
    command => "apt-get -y dist-upgrade",
    require => Class['apt::update'],
  }

  anchor { 'sqmk::apt::repo::end':
  	require => Exec['apt-get upgrade']
	}
}
