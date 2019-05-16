#'bin/bash

groupadd www
useradd -M -g www -s /bin/nologin www


yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel

wget http://nginx.org/download/nginx-1.10.3.tar.gz

tar zxvf nginx-1.10.3.tar.gz

cd nginx-1.10.3

./configure \
--user=www \
--group=www \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--prefix=/usr/local/nginx \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_v2_module \
--with-threads \
--with-stream

make && make install

mkdir /var/cache/nginx
chown www:www /var/cache/nginx
