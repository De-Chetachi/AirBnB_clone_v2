#using puppet to set up my web servers for the deployment of web_static

exec { 'update':
  command => '/usr/bin/apt-get update',
}
package { 'nginx':
  require => Exec['update'],
  ensure => installed,
}

file { '/data/':
  ensure => 'present',
  owner => 'ubuntu',
  group => 'ubuntu',
}

file { '/data/web_static/releases/test/index.html': 
  path => '/data/web_static/releases/test/index.html',
  ensure => 'present',
  content => 'test nginx config',
}

file { '/data/web_static/shared/':
  path => '/data/web_static/shared/',
  ensure => 'present',
}

file { '/data/web_static/current/':
  path => '/data/web_static/current',
  ensure => link,
  target => '/data/web_static/releases/test/',
}

file_line { 'hbnb_static'
  path => '',
  ensure => 'present',
  after => 'server_name _;',
  line => "\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}"
}

service { 'nginx':
  ensure => running,
  require => Package['nginx'],
}
