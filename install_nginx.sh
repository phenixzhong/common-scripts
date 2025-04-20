#!/bin/sh
#20160915 reorganize
#20160925 update soft version
#20161113 update openssl and nginx version
#20161204 update
#20161231 update
#20170304 update
#20170721 update
#20200201 update

install_nginx(){
  source_file_path=/var/source_file
  NGINX_VERSION=1.26.3            # http://nginx.org/en/download.html
  openssl_version=3.5.0           # https://github.com/openssl/openssl/releases
 
  #rm -r ${source_file_path}
  #mkdir -p ${source_file_path}
  cd ${source_file_path}

  #wget -O Openssl.zip https://github.com/openssl/openssl/archive/refs/tags/openssl-3.5.0.zip
  #unzip OpenSSL.zip

  #wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
  #tar -xvzf nginx-${NGINX_VERSION}.tar.gz
  cd nginx-${NGINX_VERSION}/

  ./configure \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/etc/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --with-cc=/usr/bin/clang \
  --with-openssl=${source_file_path}/openssl-openssl-3.5.0 \
  --user=www-data --group=www-data \
  --with-ipv6 \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-http_ssl_module

  make
  make install
}

install_nginx
