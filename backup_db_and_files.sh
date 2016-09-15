#!/bin/sh

backup_db_and_files(){
  local_backup_path="/var/backup"
  file_record_path_to_backup="/root/info.txt"
  file_name_record_path_to_backup="info.txt"
  file_record_db_info="mysql.txt"

  today=$(date +%Y%m%d)
  old=$(date --date='3 days ago' +%Y%m%d)
  now=$(date +%Y%m%d%H%M%S)


  mkdir -p "${local_backup_path}"/temp
  rm -r "${local_backup_path}"/lastest "${local_backup_path}/${today}"* "${local_backup_path}/${old}"*

  touch "${local_backup_path}/temp/${file_name_record_path_to_backup}"

  db_name=`cat "${file_record_db_info}" | awk '{if(NR==2) print $1;}'`
  db_user=`cat "${file_record_db_info}" | awk '{if(NR==3) print $1;}'`
  db_password=`cat "${file_record_db_info}" | awk '{if(NR==4) print $1;}'`
  gcs_bucker_name=`cat "${file_name_record_path_to_backup}" | awk '{if(NR==1) print $1;}'`

  echo "${gcs_bucker_name}" >> "${local_backup_path}/temp/${file_name_record_path_to_backup}"
  cat ${file_name_record_path_to_backup} | awk 'NR>1' | while read line
  do
    cp -r -f "${line}" "${local_backup_path}"/temp/
    echo "${line}" >>  "${local_backup_path}/temp/${file_name_record_path_to_backup}"
  done

  cd "${local_backup_path}"/temp
  mysqldump -u"${db_user}" -p"${db_password}" "${db_name}" > datebase-backup.sql
  tar zcf "${now}"-backups.tar.gz .[!.]* *

  mkdir "${local_backup_path}"/lastest
  cp ${now}-backups.tar.gz "${local_backup_path}"/lastest/lastest.tar.gz
  cp ${now}-backups.tar.gz "${local_backup_path}"/${now}-backups.tar.gz
  cd "${local_backup_path}"
  rm -r  "${local_backup_path}"/temp

  export PATH=${PATH}:/root/gsutil
  gsutil -m rsync -d -r "${local_backup_path}" "${gcs_bucker_name}"
}
