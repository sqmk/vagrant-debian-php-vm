file {'php.ini':
  path    => '/tmp/php.ini.bak',
  ensure  => present,
  mode    => 0755,
  content => 'a value'
} 
