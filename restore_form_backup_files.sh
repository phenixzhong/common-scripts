#!/bin/sh

restore(){
  file_record_backup_path="info.txt"
  file_record_db_info="mysql.txt"

  mkdir ./temp
  tar zxf lastest.tar.gz -C  ./temp/

  db_name=`cat "${file_record_db_info}" | awk '{if(NR==2) print $1;}'`
  db_user=`cat "${file_record_db_info}" | awk '{if(NR==3) print $1;}'`
  db_password=`cat "${file_record_db_info}" | awk '{if(NR==4) print $1;}'`

  cat "./temp/${file_record_backup_path}" | awk 'NR>1' | while read line
  do
    rm -r "${line}"
    cp -r -f ./temp/"${line##*/}" "${line}"
  done
  mysql -u"${db_user}" -p"${db_password}" "${db_name}" < ./temp/datebase-backup.sql
  cp ./temp/${file_record_backup_path} ./${file_record_backup_path}
  rm -r ./temp
  rm ./lastest.tar.gz
  service apache2 restart
}
restore
