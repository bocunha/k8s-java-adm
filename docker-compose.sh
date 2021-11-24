#!/bin/bash

echo "
export DATABASE_URL="mysql://localhost:3306/SpringWebYoutube"
export USER="root"
export PASSWORD="Senha12_torne00"
" >> ~/.bashrc
source ~/.bashrc

git clone --branch deploy-docker https://github.com/bocunha/spring-web-youtube.git

cd spring-web-youtube/

mvn package
./mvnw package && java -jar target/grupoone-springweb.jar

echo "
FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY \${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
" > Dockerfile

sudo docker build -t bocunha/grupoone-springweb -f Dockerfile .
sudo docker tag bocunha/grupoone-springweb hub.docker.com/r/bocunha/grupoone-springweb
sudo docker push bocunha/grupoone-springweb

#### SEGUE PARA O DEPLOY NO POD