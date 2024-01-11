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
  command => 'echo "server {\n\tlisten 80 default_server;\n\tlisten [::]:80 default_server;\n\nroot /var/www/html;\n\tindex index.html index.htm index.nginx-debian.html;\n\tserver_name _;\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}\n\n\tlocation /redirect_me {\n\t\treturn 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;\n\t}\n\terror_page 404 /custom_404.html;\n\tlocation = /custom_404.html {\n\t\troot /var/www/html;\n\t\tinternal;\n\t}\n\tlocation / {\n\t\t\# First attempt to serve request as file, then\n\t\t# First attempt to serve request as file, then\n\t\ttry_files \$uri \$uri/ =404;\n\t}\n\tadd_header X-Served-By $(hostname);\n}" > /etc/nginx/sites-available/default',
#  sed -i "/server_name _;/a \n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}"  /etc/nginx/sites-available/default,
#}
-> exec { 'restart':
  command => '/usr/sbin/service nginx restart',
}
