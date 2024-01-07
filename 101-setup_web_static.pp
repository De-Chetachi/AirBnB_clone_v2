#web static setup

exec { 'update':
  command => '/usr/bin/apt-get update',
}

-> package { 'nginx':
  require => Exec['update'],
  ensure => installed,
}

-> exec { '/data':
  command => '/usr/bin/mkdir -p "/data/web_static/shared/"',
}

-> exec { '/data/web_static/releases/test':
  command => '/usr/bin/mkdir -p "/data/web_static/releases/test/"',
}

-> exec { 'html_content': 
  command => '/usr/bin/echo "test nginx config" > "/data/web_static/releases/test/index.html"',
}

-> exec { 'symlink':
  command => '/usr/bin/ln -sf "/data/web_static/releases/test/" "/data/web_static/current"',
}

-> exec {'ownership':
  command => '/usr/bin/chown -R ubuntu:ubuntu /data/',
}

-> exec {'restart':
  command => '/usr/sbin/service nginx restart',
}

-> file { 'hbnb_static':
  path => '/etc/nginx/sites-available/default',
  ensure => 'present',
  content => template('nginx_config'),
}

-> exec {'restart':
  command => '/usr/sbin/service nginx restart',
}
