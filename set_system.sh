#!/bin/bash
# 20160915 rename fuction and variable 

set_system(){
  apt-get -y update
  apt-get -y upgrade
  dd if=/dev/zero of=/var/.swap bs=1M count=1024
  mkswap /var/.swap
  swapon /var/.swap
  echo "/var/.swap swap swap defaults 0 0" >> /etc/fstab
  echo "tmpfs /tmp tmpfs defaults 0 0" >> /etc/fstab
}

generate_db_info(){
  file_record_db_info="mysql.txt"
  touch ./"${file_record_db_info}"
  echo `date +%s%N | md5sum | head -c 12` >> ./"${file_record_db_info}"
  echo "db_"`date +%s%N | md5sum | head -c 6` >> ./"${file_record_db_info}"
  echo "u_"`date +%s%N | md5sum | head -c 6` >> ./"${file_record_db_info}"
  echo `date +%s%N | md5sum | head -c 12` >> ./"${file_record_db_info}"
  db_root_password=`cat "${file_record_db_info}" | awk '{if(NR==1) print $1;}'`
  db_name=`cat "${file_record_db_info}" | awk '{if(NR==2) print $1;}'`
  db_user_name=`cat "${file_record_db_info}" | awk '{if(NR==3) print $1;}'`
  db_user_password=`cat "${file_record_db_info}" | awk '{if(NR==4) print $1;}'`
}

intall_lamp(){
  apt-get -y install vim apache2 python
  a2enmod rewrite
  touch ./temp_file_for_db_install.txt
  echo  "mysql-server mysql-server/root_password password ${db_root_password}" > ./temp_file_for_db_install.txt
  echo  "mysql-server mysql-server/root_password_again password ${db_root_password}" >> ./temp_file_for_db_install.txt
  debconf-set-selections ./temp_file_for_db_install.txt
  apt-get -y install mysql-server php-mysql
  rm ./temp_file_for_db_install.txt
  mysql_install_db
  apt-get -y install php libapache2-mod-php php-mcrypt
}

set_db(){
  mysql -uroot \
        -p${db_root_password} \
        -e "CREATE DATABASE ${db_name}; \
            CREATE USER '${db_user_name}'@'localhost' IDENTIFIED BY '${db_user_password}'; \
            GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user_name}'@'localhost';"
}


set_system
generate_db_info
install_lamp
set_db
