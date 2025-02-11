#using puppet to set up my web servers for the deployment of web_static
#syntax error missed a : in line 44
exec { 'update':
  command => '/usr/bin/apt-get update',
}
package { 'nginx':
  require => Exec['update'],
  ensure => installed,
}

file { '/data':
  path => '/data',
  ensure => 'directory',
  owner => 'ubuntu',
  group => 'ubuntu',
  recurse => true,
}

file { '/data/web_static/releases/test':
  path => '/data/web_static/releases/test',
  ensure => 'directory',
  owner => 'ubuntu',
  group => 'ubuntu',
}

file { '/data/web_static/releases/test/index.html': 
  path => '/data/web_static/releases/test/index.html',
  ensure => 'file',
  content => 'test nginx config',
}

file { '/data/web_static/shared':
  path => '/data/web_static/shared',
  ensure => 'directory',
}

file { '/data/web_static/current/':
  path => '/data/web_static/current',
  ensure => link,
  target => '/data/web_static/releases/test/',
}

file_line { 'hbnb_static':
  path => '/etc/nginx/sites-available/default',
  ensure => 'present',
  after => 'server_name _;',
  line => "\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}"
}

exec {'restart':
  command => '/usr/sbin/service nginx restart',
}

service { 'nginx':
  ensure => running,
  require => Package['nginx'],
}
