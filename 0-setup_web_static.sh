#!/usr/bin/env bash
# sets up your web servers for the deployment of web_static
# shellcheck disable=SC2154
#check if nginx is installed
if command -v nginx >> /dev/null
then
	#I would do pass in python 
	echo "ok" >> /dev/null
else
	apt-get -y update
	apt install -y nginx
	service nginx enable
fi
#p flag to create required parent dir if it does not exist
mkdir -p "/data/web_static/shared/"
mkdir -p "/data/web_static/releases/test/"
echo "test nginx config" > "/data/web_static/releases/test/index.html"
#create a symbolic link for /data/web_static/releases/test/
ln -sf "/data/web_static/releases/test/" "/data/web_static/current"
#give ownership to "ubuntu" user and group
chown -R ubuntu:ubuntu /data/

#Update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
#create a location block for hbnb_static in /etc/nginx/sites-available
#note using root path is root + location 
#using alias replaces the path with the alias

echo "server {
	listen 80 default_server;
	listen [::]:80 default_server;


	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location /hbnb_static {
		alias /data/web_static/current/;
	}

	location /redirect_me {
		return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
	}

	error_page 404 /custom_404.html;
	location = /custom_404.html {
		root /var/www/html;
		internal;
	}

	location / {
		# First attempt to serve request as file, then
		# First attempt to serve request as file, then
		try_files \$uri \$uri/ =404;
	}

	add_header X-Served-By $(hostname);

}" > /etc/nginx/sites-available/default

service nginx restart

