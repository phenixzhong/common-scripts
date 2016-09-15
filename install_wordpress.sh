#!/bin/bash
generate_wordpress_config_file(){
  file_record_db_info="mysql.txt"
  wordpress_config_file="/var/www/wp-config.php"
  wordpress_content_path="/home/phenix/www/content"

  name=('DB_NAME'
        'DB_USER'
        'DB_PASSWORD'
        'DB_HOST'
        'DB_CHARSET')

  value=(`cat "${file_record_db_info}" | awk '{if(NR==2) print $1;}'`
       `cat "${file_record_db_info}" | awk '{if(NR==3) print $1;}'`
       `cat "${file_record_db_info}" | awk '{if(NR==4) print $1;}'`
       'localhost'
       'utf8mb4')

  more_set="\$table_prefix  = 'wp_' ;\
            define('WP_DEBUG', false); \
            define('WP_POST_REVISIONS', false); \
            define('AUTOSAVE_INTERVAL', 3600); \
            if (\$_SERVER[\"HTTP_X_FORWARDED_PROTO\"] == \"https\") \$_SERVER[\"HTTPS\"] = \"on\"; \
            \$home = (\$_SERVER[\"HTTPS\"]?\"https://\":\"http://\").\$_SERVER['HTTP_HOST'];\
            \$siteurl = (\$_SERVER[\"HTTPS\"]?\"https://\":\"http://\").\$_SERVER['HTTP_HOST'];\
            define('WP_HOME', \$home); \
            define('WP_SITEURL', \$siteurl);\
            define('WP_CONTENT_DIR', '${wordpress_content_path}'); \
            define('WP_CONTENT_URL', \$home.'/content'); \
            if ( !defined('ABSPATH') ) \
            define('ABSPATH', dirname(__FILE__) . '/');\
            require_once(ABSPATH . 'wp-settings.php');"
  touch ${wordpress_config_file}
  echo \<?php > ${wordpress_config_file}
  i=0
  while((i<${#name[*]}))
    do  
        echo define\(\'${name[i]}\', \'${value[i]}\'\)\; >> ${wordpress_config_file}
        let "i++"
    done
  echo `curl -s https://api.wordpress.org/secret-key/1.1/salt/` >> ${wordpress_config_file}
  echo ${more_set} >> ${wordpress_config_file}
}

install_wordpress(){
  wget https://wordpress.org/latest.tar.gz
  tar zxf latest.tar.gz -C /var/www/
  cp -r -f /var/www/wordpress/* /var/www/html/
  rm -r -f /var/www/wordpress
  rm latest.tar.gz
  chown -R www-data:www-data /var/www/html
}

generate_wordpress_config_file
install_wordpress
