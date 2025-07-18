#!/bin/bash

mkdir -p user-certs

declare -A USERS=(
  ["cluster-admin-user"]="system:masters"
  ["security-admin-user"]="security"
  ["devops-engineer-user"]="devops"
  ["developer-user"]="developers"
  ["viewer-user"]="viewers"
)

for USER in "${!USERS[@]}"; do
  GROUP=${USERS[$USER]}
  
  echo "Создаем пользователя $USER в группе $GROUP"
  
  openssl genrsa -out users/${USER}.key 2048
  
  openssl req -new -key users/${USER}.key -out users/${USER}.csr -subj "/CN=${USER}/O=${GROUP}"
  
  openssl x509 -req -in users/${USER}.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key \
    -CAcreateserial -out users/${USER}.crt -days 365
  
  chmod 600 users/${USER}.key
  
  kubectl config set-credentials ${USER} \
    --client-certificate=users/${USER}.crt \
    --client-key=users/${USER}.key \
    --embed-certs=true

  CONTEXT_NAME="${USER}-context"
  
  if [[ "$USER" == "viewer-user" || "$USER" == "developer-user" ]]; then
    NAMESPACE="dev"
    kubectl config set-context ${CONTEXT_NAME} \
      --cluster=minikube \
      --namespace=${NAMESPACE} \
      --user=${USER}
  else
    kubectl config set-context ${CONTEXT_NAME} \
      --cluster=minikube \
      --user=${USER}
  fi
  
  echo "✔ Пользователь $USER и контекст $CONTEXT_NAME созданы"
  echo "----------------------------------------"
done

echo "Все пользователи успешно созданы:"
printf "%s\n" "${!USERS[@]}"