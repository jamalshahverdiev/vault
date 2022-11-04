#!/bin/sh
DEPLOYMENT=$(echo $HOSTNAME | sed '$s/-\w*$//g;$s/-\w*$//g')
DEPLOYMENT_STATUS=$(kubectl rollout status deploy $DEPLOYMENT --watch=false)

echo $DEPLOYMENT_STATUS | grep  'successfully rolled out'
if [ $? == 0 ]; then
    echo "Restarting deployment"
    kubectl rollout restart deploy $DEPLOYMENT
else
    echo "Rollout already inprogress. Skipping"
fi
