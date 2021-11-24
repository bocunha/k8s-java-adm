#!/bin/bash
PODPATH=$PWD
CHAVESSH="/var/lib/jenkins/.ssh/grupo-one.pem"
#################

ID_M1_DNS=`grep ID_M1_DNS /tmp/ipmasters.tmp | cut -d"=" -f2`
# ID_MYSQL_PROD=`grep ID_M1_DNS /tmp/ipmasters | cut -d"=" -f2`
# ID_MYSQL_STAGE=`grep ID_M1_DNS /tmp/ipmasters | cut -d"=" -f2`
# ID_MYSQL_DEV=`grep ID_M1_DNS /tmp/ipmasters | cut -d"=" -f2`
ID_MYSQL_PROD="192.168.100.114"
ID_MYSQL_STAGE="192.168.100.22"
ID_MYSQL_DEV="192.168.100.11"


echo "
[k8s-master-1]
${ID_M1_DNS}
" > $PODPATH/hosts

echo "
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-configmap
data:
  USER: root
  # PASSWORD: password_mysql
  DATABASE_URL: mysql://${ID_MYSQL_PROD}:3306/SpringWebYoutube
" > $PODPATH/mysql-config/mysql-configmap_prod.yml

ansible-playbook -i hosts prod.yml -u ubuntu --private-key ${CHAVESSH}
