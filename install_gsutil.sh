#!/bin/bash
#install gsutil

install_gsutil(){
  wget https://storage.googleapis.com/pub/gsutil.tar.gz
  tar xfz gsutil.tar.gz -C /root/
  rm gsutil.tar.gz
  echo "export PATH=\${PATH}:\$HOME/gsutil" >> /root/.bashrc
  export PATH=${PATH}:/root/gsutil

  gsutil update
  gsutil config
}

install_gsutil
