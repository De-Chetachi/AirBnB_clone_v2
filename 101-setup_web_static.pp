#web static setup
exec { 'update':
  command => '/usr/bin/apt-get update',
}
-> package { 'nginx':
  ensure => installed,
}
-> exec { 'data':
  command => '/usr/bin/mkdir -p "/data/web_static/shared/"',
}
-> exec { 'test':
  command => '/usr/bin/mkdir -p "/data/web_static/releases/test/"',
}
-> exec { 'htmlcontent': 
  command => '/usr/bin/echo "test nginx config" > "/data/web_static/releases/test/index.html"',
}
-> exec { 'symlink':
  command => '/usr/bin/ln -sf "/data/web_static/releases/test/" "/data/web_static/current"',
}
-> exec { 'ownership':
  command => '/usr/bin/chown -R ubuntu:ubuntu /data/',
}

-> exec { 'hbnb_static':
  sed -i "/server_name _;/a  \n\tlocation /hbnb_static {alias /data/web_static/current/;\n\t}"  /etc/nginx/sites-available/default
-> exec { 'restart':
  command => '/usr/sbin/service nginx restart',
}
