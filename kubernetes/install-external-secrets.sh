#!/bin/bash
set -e

echo "🔒 Installing External Secrets Operator (ESO)..."

# Add External Secrets Helm repository
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

# Create namespace and install release
kubectl create namespace external-secrets --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install external-secrets \
  external-secrets/external-secrets \
  --namespace external-secrets \
  --set installCRDs=true

echo "✅ External Secrets Operator installed successfully!"
echo "📄 Apply SecretStore and ExternalSecret manifests:"
echo "   kubectl apply -f kubernetes/external-secret.yaml"
