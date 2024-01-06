#using puppet to set up my web servers for the deployment of web_static
#syntax error missed a : in line 44
exec { 'update':
  command => '/usr/bin/apt-get update',
}
package { 'nginx':
  require => Exec['update'],
  ensure => installed,
}

exec { '/data':
  command => 'mkdir -p "/data/web_static/shared/"',
}

exec { '/data/web_static/releases/test':
  command => 'mkdir -p "/data/web_static/releases/test/"',
}

exec { 'html_content': 
  command => 'echo "test nginx config" > "/data/web_static/releases/test/index.html"',
}

exec { 'symlink':
  command => 'ln -sf "/data/web_static/releases/test/" "/data/web_static/current"',
}

exec {'ownership':
  command => 'chown -R ubuntu:ubuntu /data/',
}

exec {'restart':
  command => '/usr/sbin/service nginx restart',
}

file { 'hbnb_static':
  path => '/etc/nginx/sites-available/default',
  ensure => 'present',
  content => template('nginx_config'),
}

exec {'restart':
  command => '/usr/sbin/service nginx restart',
}

service { 'nginx':
  ensure => running,
  require => Package['nginx'],
}
