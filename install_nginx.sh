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
# NPS_VERSION=1.13.35.2-stable  # https://github.com/pagespeed/ngx_pagespeed/releases
  NGINX_VERSION=1.17.8            # http://nginx.org/en/download.html
  openssl_version=1_1_1d           # https://github.com/openssl/openssl/releases
  nginx_ct_version=1.3.2          # https://github.com/grahamedgecombe/nginx-ct/releases/latest

  rm -r ${source_file_path}
  mkdir -p ${source_file_path}
  cd ${source_file_path}
#  wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip
#  unzip v${NPS_VERSION}.zip
#  nps_dir=$(find . -name "*pagespeed-ngx-${NPS_VERSION}" -type d)
#  cd "$nps_dir"
#  NPS_RELEASE_NUMBER=${NPS_VERSION}/stable/
#  psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
#  [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
#  wget ${psol_url}
#  tar -xzvf $(basename ${psol_url})  # extracts to psol/
#
#  cd ${source_file_path}
  wget -O nginx-ct.zip https://github.com/grahamedgecombe/nginx-ct/archive/v${nginx_ct_version}.zip
  unzip nginx-ct.zip

  wget -O openssl.zip https://github.com/openssl/openssl/archive/OpenSSL_${openssl_version}.zip
  unzip openssl.zip

  wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
  tar -xvzf nginx-${NGINX_VERSION}.tar.gz
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
  --with-openssl=${source_file_path}/openssl-OpenSSL_${openssl_version} \
  --user=www-data --group=www-data \
  --with-ipv6 \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-http_ssl_module \
# --add-module=${source_file_path}/$nps_dir \
  --add-module=${source_file_path}/nginx-ct-${nginx_ct_version}

  make
  make install
}

install_nginx
