#!/bin/bash

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=cluster-admin-user

kubectl create clusterrolebinding security-admin-binding \
  --clusterrole=security-admin \
  --user=security-admin-user

kubectl create clusterrolebinding devops-engineer-binding \
  --clusterrole=devops-engineer \
  --user=devops-engineer-user

kubectl create rolebinding developer-binding \
  --namespace=dev \
  --role=developer \
  --user=developer-user

kubectl create rolebinding viewer-dev-binding \
  --namespace=dev \
  --clusterrole=viewer \
  --user=viewer-user

kubectl create rolebinding viewer-production-binding \
  --namespace=production \
  --clusterrole=viewer \
  --user=viewer-user

echo "Привязки ролей созданы"