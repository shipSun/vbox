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

mkdir /usr/local/nginx/conf/conf.d/

sed -i 's/#user  nobody;/user  www;/g' /usr/local/nginx/conf/nginx.conf;
sed -i 's/#gzip  on;/gzip  on;/g' /usr/local/nginx/conf/nginx.conf;
sed -i '$iinclude conf\.d\/\*\.conf;' /usr/local/nginx/conf/nginx.conf


echo '#!/bin/bash
#shebang机制  
# nginx Startup script for the Nginx HTTP Server  
# 
# author: ship 
# chkconfig: 4 85 15  
# description: Nginx is a high-performance web and proxy server.   
# processname: nginx  
# pidfile: /var/run/nginx.pid  
# config: /usr/local/nginx/conf/nginx.conf  
nginxd=/usr/local/nginx/sbin/nginx  
nginx_config=/usr/local/nginx/conf/nginx.conf  
nginx_pid=/var/run/nginx.pid  
 
RETVAL=0  
prog="nginx" 
 
# Source function library.  
.  /etc/rc.d/init.d/functions  
 
# Source networking configuration.  
. /etc/sysconfig/network  
 
# Check that networking is up.  
[ ${NETWORKING} = "no" ] && exit 0  
 
[ -x $nginxd ] || exit 0  
 
 
# Start nginx daemons functions.  
start() {  
 
if [ -e $nginx_pid ];then 
pid=`ps -e | grep nginx | awk 'NR==1{print$1}'`
diffpid=`cat $nginx_pid`
if [ $pid -ne $diffpid ];then
   rm -rf $nginx_pid
   start
   return 0
fi
   echo "nginx already running...." 
   exit 1  
fi  
 
   echo -n $"Starting $prog: " 
   daemon $nginxd -c ${nginx_config}  
   RETVAL=$?  
   echo  
   [ $RETVAL = 0 ] && touch /var/lock/subsys/nginx  
   return $RETVAL  
 
}  
 
 
# Stop nginx daemons functions.  
stop() {  
        echo -n $"Stopping $prog: " 
        killproc $nginxd  
        RETVAL=$?  
        echo  
        [ $RETVAL = 0 ] && rm -f /var/lock/subsys/nginx /var/run/nginx.pid  
}  
 
 
# reload nginx service functions.  
reload() {  
 
    echo -n $"Reloading $prog: " 
    killproc $nginxd -HUP
    #if your nginx version is below 0.8, please use this command: "kill -HUP `cat ${nginx_pid}`" 
    RETVAL=$?
    echo  
    return $RETVAL
}  
 
# See how we were called.  
case "$1" in 
start)  
        start  
        ;;  
 
stop)  
        stop  
        ;;  
 
reload)  
        reload  
        ;;  
 
restart)  
        stop  
        start  
        ;;  
 
status)  
        status $prog  
        RETVAL=$?  
        ;;  
*)  
        echo $"Usage: $prog {start|stop|restart|reload|status|help}" 
        exit 1  
esac  
 
exit $RETVAL ' > /usr/local/nginx/sbin/nginx.service

chmod +x /usr/local/nginx/sbin/nginx.service

ln -s /usr/local/nginx/sbin/nginx.service /etc/init.d/nginx

chkconfig --add nginx
