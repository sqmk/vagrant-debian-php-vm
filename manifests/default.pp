file { 'php.ini':
  path    => '/tmp/php.ini.bak',
  ensure  => present,
  mode    => 0755,
  content => 'a value'
} 

class { 'apt':
  always_apt_update => true,
}

class mysql {

  package { "mysql-server": 
    ensure => installed,
  }

  service { "mysql":
    ensure => running,
  }
}

class rabbitmq {
	
  package { "rabbitmq-server":
    ensure => installed,
  }

  service { "rabbitmq-server":
    ensure => running,
  }
}

include mysql
include rabbitmq