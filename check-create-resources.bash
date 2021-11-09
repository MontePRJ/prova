#!/bin/bash

#Utilizziamo questo script per eseguire un check sulle risorse presenti e per creare e aggiornare quelle modificate

#Variabili
export USAGE="Usage ./create_resources.sh <PATH_VOLUME> <OCP_PROJECT>"
export PATH_VOLUME=$1
export OCP_PROJECT=$2
export PATH_SETUP_SERVICE=${PATH_VOLUME}"/setup.txt"
export PATH_ELENCO_MICROSERVIZI=${PATH_VOLUME}"/elenco_microservizi.csv"

export LISTA_MICROSERVIZI=`cat ${PATH_ELENCO_MICROSERVIZI} | grep -v '^#'`

exit 0

for i in `echo $LISTA_MICROSERVIZI`; do
    export NOME_MICROSERVIZIO=`echo $i | cut -d ';' -f 2`
    export BC=`cat ${PATH_SETUP_SERVICE} | grep ^$NOME_MICROSERVIZIO\; | grep ';bc;' | cut -d ';' -f 3`
    export DC=`cat ${PATH_SETUP_SERVICE} | grep ^$NOME_MICROSERVIZIO\; | grep ';dc;' | cut -d ';' -f 3`
    export SERVICE=`cat ${PATH_SETUP_SERVICE} | grep ^$NOME_MICROSERVIZIO\; | grep ';service;' | cut -d ';' -f 3`
    export ROTTA=`cat ${PATH_SETUP_SERVICE} | grep ^$NOME_MICROSERVIZIO\; | grep ';rotta;' | cut -d ';' -f 3`
    export CONFIGMAP=`cat ${PATH_SETUP_SERVICE} | grep ^$NOME_MICROSERVIZIO\; | grep ';configmap;' | cut -d ';' -f 3`
    export SECRET=`cat ${PATH_SETUP_SERVICE} | grep ^$NOME_MICROSERVIZIO\; | grep ';secret;' | cut -d ';' -f 3`  
        
    if [[ $BC == "true" ]]; then
    oc delete bc/${NOME_MICROSERVIZIO} -n $(params.OCP_PROJECT)
    oc create -f bc.yml -n $(params.OCP_PROJECT)
    fi

    if [[ $DC == "true" ]]; then
    oc delete dc/${NOME_MICROSERVIZIO} -n $(params.OCP_PROJECT)
    oc create -f dc.yml -n $(params.OCP_PROJECT)
    fi         

    if [[ $SERVICE == "true" ]]; then
    oc delete service/${NOME_MICROSERVIZIO} -n $(params.OCP_PROJECT)
    oc create -f service.yml -n $(params.OCP_PROJECT)
    fi   

    if [[ $ROTTA == "true" ]]; then
    oc delete rotta/${NOME_MICROSERVIZIO} -n $(params.OCP_PROJECT)
    oc create -f rotta.yml -n $(params.OCP_PROJECT)
    fi  

    if [[ $CONFIGMAP == "true" ]]; then
    oc delete configmap/${NOME_MICROSERVIZIO} -n $(params.OCP_PROJECT)
    oc create -f configmap.yml -n $(params.OCP_PROJECT)
    fi  

    if [[ $SECRET == "true" ]]; then
    oc delete secret/${NOME_MICROSERVIZIO} -n $(params.OCP_PROJECT)
    oc create -f secret.yml -n $(params.OCP_PROJECT)
    fi  
done