#!/bin/sh
#20160915 reorganize
#20160925 update soft version
#20161113 update openssl and nginx version
#20161204 update
#20161231 update

install_nginx(){
  source_file_path=/var/source_file
  ngx_pagespeed_version=1.11.33.4 # https://github.com/pagespeed/ngx_pagespeed/releases
  nginx_version=1.11.8            # http://nginx.org/en/download.html
  openssl_version=1_1_0c           # https://github.com/openssl/openssl/releases
  nginx_ct_version=1.3.2          # https://github.com/grahamedgecombe/nginx-ct/releases/latest

  rm -r ${source_file_path}
  mkdir -p ${source_file_path}
  cd ${source_file_path}
  wget https://github.com/pagespeed/ngx_pagespeed/archive/v${ngx_pagespeed_version}-beta.zip -O v${ngx_pagespeed_version}-beta.zip
  unzip v${ngx_pagespeed_version}-beta.zip
  cd ngx_pagespeed-${ngx_pagespeed_version}-beta/
  psol_url=https://dl.google.com/dl/page-speed/psol/${ngx_pagespeed_version}.tar.gz
  [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
  wget ${psol_url}
  tar -xzvf $(basename ${psol_url})

  cd ${source_file_path}
  wget -O nginx-ct.zip https://github.com/grahamedgecombe/nginx-ct/archive/v${nginx_ct_version}.zip
  unzip nginx-ct.zip

  wget -O openssl.zip https://github.com/openssl/openssl/archive/OpenSSL_${openssl_version}.zip
  unzip openssl.zip

  wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
  tar -xvzf nginx-${nginx_version}.tar.gz
  cd nginx-${nginx_version}/

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
  --add-module=${source_file_path}/ngx_pagespeed-${ngx_pagespeed_version}-beta \
  --add-module=${source_file_path}/nginx-ct-${nginx_ct_version}

  make
  make install
}

install_nginx
