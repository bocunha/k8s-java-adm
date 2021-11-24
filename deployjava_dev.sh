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
  name: mysql-configmap-dev
data:
  USER: root
  # PASSWORD: password_mysql
  DATABASE_URL: mysql://${ID_MYSQL_DEV}:3306/SpringWebYoutube
" > $PODPATH/app-config/mysql-configmap_dev.yml

echo "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-deployment-dev
spec:
  template:
    metadata:
      name: pod-javadb-dev
      labels:
        app: pod-javadb-dev
    spec:
      containers:
        - name: container-pod-javadb
          image: bocunha/grupoone-springweb
          env:
            - name: USER
              valueFrom:
                configMapKeyRef:
                  name: mysql-configmap-dev
                  key: USER
            - name: PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: PASSWORD
            - name: DATABASE_URL
              valueFrom:
                configMapKeyRef:
                  name: mysql-configmap-dev
                  key: DATABASE_URL
          ports:
            - containerPort: 8080
          resources:
            requests:
              memory: "512Mi"
              cpu: "0.5"
            limits: 
              memory: "800Mi" 
              cpu: "1"
  replicas: 2
  selector:
    matchLabels:
      app: pod-javadb-dev
" > $PODPATH/app-config/deployment_dev.yml

ansible-playbook -i hosts dev.yml -u ubuntu --private-key ${CHAVESSH}

sleep 30