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
" > $PODPATH/app-config/mysql-configmap_prod.yml


echo "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-deployment-prod
spec:
  template:
    metadata:
      name: pod-javadb-prod
      labels:
        app: pod-javadb-prod
    spec:
      containers:
        - name: container-pod-javadb
          image: bocunha/grupoone-springweb
          env:
            - name: USER
              valueFrom:
                configMapKeyRef:
                  name: mysql-configmap-prod
                  key: USER
            - name: PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: PASSWORD
            - name: DATABASE_URL
              valueFrom:
                configMapKeyRef:
                  name: mysql-configmap-prod
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
      app: pod-javadb-prod
" > $PODPATH/app-config/deployment_prod.yml


ansible-playbook -i hosts prod.yml -u ubuntu --private-key ${CHAVESSH}



sleep 30