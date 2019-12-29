#!/bin/bash

COMMAND=$@
if [ "$COMMAND" = "create" ]; then
  k3d create --publish 8888:80 --workers 2 --name operator
  sleep 5 # wait until the kubeconfig is available, https://github.com/rancher/k3d/issues/159
  k3d list
  KUBECONFIG="$(k3d get-kubeconfig --name='operator')"
  export KUBECONFIG

  # Helm
  echo "----------------------------------------------------------------"
  echo "Installing Helm..."
  echo "----------------------------------------------------------------"
  kubectl -n kube-system create serviceaccount tiller
  kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
  if helm init --service-account tiller --wait --history-max 10; then
    echo "----------------------------------------------------------------"
    echo "Helm has been successfully installed."
    echo "----------------------------------------------------------------"
  fi

  # Cadence server
  echo "----------------------------------------------------------------"
  echo "Installing Cadence server..."
  echo "----------------------------------------------------------------"
  helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com >/dev/null
  helm repo update >/dev/null
  if helm install --name cadence --set server.image.tag=0.10.3 --set web.image.tag=3.4.1 banzaicloud-stable/cadence --namespace cadence-system --version 0.4.0 --set cassandra.enabled=false --set mysql.enabled=true --set mysql.mysqlPassword=cadence --set "web.service.type=NodePort" --set "web.service.nodePort=30777"; then
    cadence_ingress=$(
      cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: cadence-web
  namespace: cadence-system
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
    - http:
        paths:
          - path: /
            backend:
              serviceName: cadence-web
              servicePort: 80
EOF
    )
    if [[ $cadence_ingress == *" created"* ]]; then
      echo "----------------------------------------------------------------"
      echo "Cadence server has been successfully installed."
      echo "----------------------------------------------------------------"
    fi
  fi
elif [ "$COMMAND" = "delete" ]; then
  k3d delete --name=operator
elif [ "$COMMAND" = "start" ]; then
  k3d start --name=operator
  KUBECONFIG="$(k3d get-kubeconfig --name='operator')"
  export KUBECONFIG
  sleep 10 # wait until the cluster is available, https://github.com/rancher/k3d/issues/159
  kubectl scale --replicas 1 deployment/cadence-web deployment/cadence-history deployment/cadence-frontend deployment/cadence-worker deployment/cadence-matching deployment/cadence-mysql
elif [ "$COMMAND" = "stop" ]; then
  kubectl scale --replicas 0 deployment/cadence-web deployment/cadence-history deployment/cadence-frontend deployment/cadence-worker deployment/cadence-matching deployment/cadence-mysql
  kubectl delete pod --all --force --grace-period=0
  k3d stop --name=operator
else
  echo -e "\nYou must enter one of the following commands:\n"
  echo -e "   create    Create dev K8s environment"
  echo -e "   delete    Delete dev K8s environment"
  echo -e "   start     Start operator in K8s environment"
  echo -e "   stop      Stop K8s environment\n"
fi
