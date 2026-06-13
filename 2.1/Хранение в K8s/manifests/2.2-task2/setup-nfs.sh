#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NFS_IP="$(minikube ip)"

echo "NFS server address: ${NFS_IP}"

kubectl apply -f "${DIR}/nfs-server.yaml"
kubectl wait --for=condition=Ready pod -l app=nfs-server --timeout=120s

sed "s/__NFS_SERVER__/${NFS_IP}/g" "${DIR}/nfs-provisioner.yaml.tpl" | kubectl apply -f -

kubectl wait --for=condition=Ready pod -l app=nfs-client-provisioner --timeout=120s
kubectl apply -f "${DIR}/pvc.yaml"
sleep 5
kubectl get pvc nfs-pvc
kubectl get pv

kubectl apply -f "${DIR}/deployment.yaml"
kubectl wait --for=condition=Ready pod -l app=nfs-multitool --timeout=120s

POD="$(kubectl get pod -l app=nfs-multitool -o jsonpath='{.items[0].metadata.name}')"
kubectl exec "$POD" -c multitool -- sh -c \
  'echo "hello from nfs $(date -Iseconds)" > /nfs-data/test.txt && cat /nfs-data/test.txt'

echo "NFS task2 ready. Pod: ${POD}"
