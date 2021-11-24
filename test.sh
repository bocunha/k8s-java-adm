#!/bin/bash
## VARIAVEIS
PODPATH="$PWD"
CHAVESSH="/var/lib/jenkins/.ssh/grupo-one.pem"
ID_M1_DNS=`grep ID_M1_DNS /tmp/ipmasters | cut -d"=" -f2`
###########################

$CHKJAVA=$(curl -Sk $ID_M1_DNS:30002)
#PEGA O ESTADO DO TERRAFORM
if [[ $CHKJAVA -eq 6 ]]
then 
    echo "::::: server está no ar :::::"
    exit 0
else
    echo "::::: server não está no ar :::::"
    exit 1
fi