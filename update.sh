#!/bin/bash

if [ -z ${PLUGIN_NAMESPACE} ]; then
  PLUGIN_NAMESPACE="default"
fi

if [ -z ${PLUGIN_CONFIGFILE_NAME} ]; then
  PLUGIN_CONFIGFILE_NAME="KUBECONFIG_FILE"
fi

if [ -z ${PLUGIN_KUBERNETES_USER} ]; then
  PLUGIN_KUBERNETES_USER="default"
fi

#chosing between multiple config files is easy!
#pass a variable with the configfile name and the configfile with the same name
CONFIGFILE_NAME=$PLUGIN_CONFIGFILE_NAME

#creates a base64 config file then adds it to the container
mkdir -p $HOME/.kube
echo ${!CONFIGFILE_NAME} > /tmp/configfile
base64 -d /tmp/configfile > $HOME/.kube/config

# kubectl version
IFS=',' read -r -a DEPLOYMENTS <<< "${PLUGIN_DEPLOYMENT}"
IFS=',' read -r -a CONTAINERS <<< "${PLUGIN_CONTAINER}"
for DEPLOY in ${DEPLOYMENTS[@]}; do
  echo Deploying to K8s Server
  for CONTAINER in ${CONTAINERS[@]}; do
    if [[ ${PLUGIN_FORCE} == "true" ]]; then
      kubectl -n ${PLUGIN_NAMESPACE} set image deployments/${DEPLOY} \
        ${CONTAINER}=${PLUGIN_REPO}:${PLUGIN_TAG}FORCE
    fi
    kubectl -n ${PLUGIN_NAMESPACE} set image deployments/${DEPLOY} \
      ${CONTAINER}=${PLUGIN_REPO}:${PLUGIN_TAG} --record
  done
done
