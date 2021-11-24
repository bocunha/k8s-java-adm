#!/bin/bash
## VARIAVEIS
PODPATH="$PWD"
CHAVESSH="/var/lib/jenkins/.ssh/grupo-one.pem"
ID_M1_DNS=`grep ID_M1_DNS /tmp/ipmasters.tmp | cut -d"=" -f2`
###########################

curl -v $ID_M1_DNS:30003

#PEGA O ESTADO DO TERRAFORM

if [[ $? -eq 0 ]]
then 
    echo "::::: server está no ar :::::"
    exit 0
else
    echo "::::: server não está no ar :::::"
    exit 1
fi