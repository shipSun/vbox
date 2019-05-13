#/bin/bash
wget http://mirrors.neusoft.edu.cn/mariadb//mariadb-10.3.14/source/mariadb-10.3.14.tar.gz

tar zxvf mariadb-10.3.14.tar.gz

yum -y install openssl-devel ncurse-devel bison

cd mariadb-10.3.14

groupadd www

useradd -g www -s /bin/nologin www

cmake . \
-DCMAKE_INSTALL_PREFIX=/usr/local/mariaDB \
-DINSTALL_SBINDIR=/usr/local/mariaDB/bin \
-DMYSQL_DATADIR=/var/local/data \
-DINSTALL_PLUGINDIR=/usr/local/mariaDB/plugin \
-DINSTALL_MANDIR=/usr/local/mariaDB/share/man \
-DINSTALL_SHAREDIR=/usr/local/mariaDB/share \
-DINSTALL_LIBDIR=/usr/local/mariaDB/lib/mysql \
-DINSTALL_INCLUDEDIR=/usr/local/mariaDB/include/mysql \
-DINSTALL_INFODIR=/usr/local/mariaDB/share/info \
-DDEFAULT_CHARSET="utf8mb4" \
-DDEFAULT_COLLATION="utf8mb4_general_ci" \
-DMYSQL_DATADIR=/usr/local/mariaDB/data \
-DMYSQL_USER=www \
-DMYSQL_UNIX_ADDR=/var/run/mariaDB/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DWITH_SSL=system \
-DWITH_ZLIB=system \
-DWITH_READLINE=1 \
-DWTIH_LIBWRAP=0 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_EMBEDDED_SERVER=0 \
-DWITH_DEBUG=0\
-DENABLE_PROFILING=1\
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 

make && make install

cd /usr/local/mariaDB

/usr/local/mariaDB/scripts/mysql_install_db --user=www --basedir=/usr/local/mariaDB --datadir=/var/local/data
