#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR="${DIR}/certs"
CA_CERT="${MINIKUBE_CA_CERT:-${HOME}/.minikube/ca.crt}"
CA_KEY="${MINIKUBE_CA_KEY:-${HOME}/.minikube/ca.key}"
USER_NAME="${1:-developer}"

mkdir -p "${CERT_DIR}"

openssl genrsa -out "${CERT_DIR}/${USER_NAME}.key" 2048
openssl req -new -key "${CERT_DIR}/${USER_NAME}.key" -out "${CERT_DIR}/${USER_NAME}.csr" \
  -subj "/CN=${USER_NAME}"
openssl x509 -req -in "${CERT_DIR}/${USER_NAME}.csr" \
  -CA "${CA_CERT}" -CAkey "${CA_KEY}" -CAcreateserial \
  -out "${CERT_DIR}/${USER_NAME}.crt" -days 365

echo "Created:"
echo "  ${CERT_DIR}/${USER_NAME}.key"
echo "  ${CERT_DIR}/${USER_NAME}.crt"
