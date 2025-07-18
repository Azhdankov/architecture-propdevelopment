#!/bin/bash

kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace production --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: viewer
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch"]
EOF

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: dev
  name: developer
rules:
- apiGroups: ["", "apps"]
  resources: ["deployments", "pods", "services"]
  verbs: ["*"]
EOF

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: devops-engineer
rules:
- apiGroups: ["", "apps"]
  resources: ["deployments", "pods", "services"]
  verbs: ["*"]
EOF

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: security-admin
rules:
- apiGroups: [""]
  resources: ["secrets", "pods"]
  verbs: ["*"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list", "watch"]
EOF

echo "Роли созданы"