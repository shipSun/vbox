#!/bin/bash
groupadd www
useradd -M -g www -s /bin/nologin www

yum -y install freetype libxml2-devel openssl-devel bzip2-devel curl-devel libjpeg-devel libpng-devel libXpm-devel freetype-devel gmp-devel libmcrypt-devel mysql-devel aspell-devel recode-devel icu libicu-devel gcc gcc-c++ autoconf

wget https://www.php.net/distributions/php-5.4.40.tar.gz

tar zxvf php-5.6.40.tar.gz

cd php-5.6.40

./configure \
--prefix=/usr/local/php5 \
--exec-prefix=/usr/local/php5 \
--bindir=/usr/local/php5/bin \
--sbindir=/usr/local/php5/sbin \
--includedir=/usr/local/php5/include \
--libdir=/usr/local/php5/lib/php \
--mandir=/usr/local/php5/php/man \
--with-config-file-path=/usr/local/php5/etc \
--with-config-file-scan-dir=/usr/local/php5/etc/php.d \
--with-mhash \
--with-openssl \
--with-mysqli=shared,mysqlnd \
--with-pdo-mysql=shared,mysqlnd \
--with-gd \
--with-iconv \
--with-zlib \
--enable-zip \
--enable-intl  \
--enable-inline-optimization \
--enable-debug \
--disable-rpath \
--enable-shared \
--enable-xml \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-mbregex \
--enable-mbstring \
--enable-ftp \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-soap \
--without-pear \
--with-gettext \
--enable-session \
--with-curl \
--with-jpeg-dir \
--with-freetype-dir \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--without-gdbm

make && make install

if [ ! -f "/usr/local/sbin/php" ];then

ln -s /usr/local/php5/bin/php /usr/local/sbin/php

fi

cp php.ini-production /usr/local/php5/etc/php.ini

cp /usr/local/php5/etc/php-fpm.conf.default /usr/local/php5/etc/php-fpm.conf

sed -i 's/;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/g' /usr/local/php5/etc/php-fpm.conf
sed -i 's/;error_log = log\/php-fpm.log/error_log = log\/php-fpm.log/g' /usr/local/php5/etc/php-fpm.conf

sed -i 's/;date.timezone =/date.timezone =Asia\/Shanghai/g' /usr/local/php5/etc/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /usr/local/php5/etc/php.ini

echo '#!/bin/bash  
#Startup script for the PHP-FPM service.  
# chkconfig:4 85 20
# description: PHP-FPM is fast-cgi ctrl programme  
#  
phpfpm=/usr/local/php5/sbin/php-fpm  
phpfpm_config=/usr/local/php5/etc/php-fpm.conf  
phpfpm_pid=/usr/local/php5/php-fpm.pid  
php_config=/usr/local/php5/etc/php.ini  
  
RETYAL=0  
prog="php-fpm"  
  
. /etc/rc.d/init.d/functions  
#Source network configuration.  
. /etc/sysconfig/network  
#Check that networking is up.  
[ ${NETWORKING} = "no" ] && exit 0  
[ -x $phpfpm ] || exit 0  
  
start() {  
    [ -x $phpfpm ] || \
        { echo "FATAL: No such programme";exit 4; }  
    [ -f $phpfpm_config ] || \
	{ echo "FATAL: Config file does not exist";exit 6; }  
    if [ -e $phpfpm_pid ];then 
        pid=`ps -e | grep php-fpm | awk "NR==1{print$1}"`
	diffpid=`cat $phpfpm_pid`
	if [ $pid -ne $diffpid ];then
		rm -rf $phpfpm_pid
		start
		return 0
	fi
        echo -n $"$prog already running...."  
        exit 1  
    fi  
    echo -n $"Starting $prog services:"  
    daemon $phpfpm -c $php_config -y ${phpfpm_config}  
    RETVAL=$?  
    echo  
    [ $RETVAL = 0 ] && touch /var/lock/subsys/php-fpm  
    return $RETVAL  
}  
  
stop() {  
    echo -n $"Stoping $prog services:"  
    killproc $phpfpm  
    RETVAL=$?  
    echo  
    [ $RETVAL = 0 ] && rm -f /var/lock/subsys/php-fpm $phpfpm_pid  
}  
  
test() {  
    echo -n $"Test $phpfpm_config file:"  
    $phpfpm -c ${php_config} -y ${phpfpm_config} -t  
    RETVAL=$?  
    echo  
}  
  
case "$1" in  
    start)  
        start  
        ;;  
    stop)  
        stop  
        ;;  
    test)  
        configtest  
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
        echo $"Usage:$prog{start|stop|restart|test|status|help}"  
        exit 1  
esac  
exit $RETVAL' > /usr/local/php5/sbin/php-fpm.service

chmod +x /usr/local/php5/sbin/php-fpm.service

if [ ! -f "/etc/init.d/php-fpm" ];then 

ln -s /usr/local/php5/sbin/php-fpm.service /etc/init.d/php-fpm

fi

chkconfig --add php-fpm
