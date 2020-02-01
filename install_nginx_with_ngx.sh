#!/bin/sh

install_nginx(){
  source_file_path=/var/source_file
  NGINX_VERSION=1.17.8            # http://nginx.org/en/download.html
  openssl_version=1_1_1d           # https://github.com/openssl/openssl/releases
  nginx_ct_version=1.3.2          # https://github.com/grahamedgecombe/nginx-ct/releases/latest
  
  
  rm -r ${source_file_path}
  mkdir -p ${source_file_path}
  cd ${source_file_path}

  wget -O nginx-ct.zip https://github.com/grahamedgecombe/nginx-ct/archive/v${nginx_ct_version}.zip
  unzip nginx-ct.zip

  wget -O openssl.zip https://github.com/openssl/openssl/archive/OpenSSL_${openssl_version}.zip
  unzip openssl.zip
  
  bash <(curl -f -L -sS https://ngxpagespeed.com/install) -n ${NGINX_VERSION} -v latest  -a '\
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/etc/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --with-cc=/usr/bin/clang \
  --with-openssl=${source_file_path}/openssl-OpenSSL_${openssl_version} \
  --user=www-data --group=www-data \
  --with-ipv6 \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-http_ssl_module \
  --add-module=${source_file_path}/nginx-ct-${nginx_ct_version}'
  }
  
 install_nginx
