#!/usr/bin/env bash
# Установка кластера 3.2: 1 master + 4 worker, containerd, etcd на master
set -euo pipefail

PROFILE="${1:-k8s-32}"
NODES="${2:-5}"

minikube start -p "${PROFILE}" \
  --nodes "${NODES}" \
  --container-runtime=containerd \
  --driver=docker

echo "--- kubectl get nodes ---"
kubectl get nodes -o wide
