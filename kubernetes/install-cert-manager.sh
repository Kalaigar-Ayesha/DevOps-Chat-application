#!/bin/bash
set -e

echo "🔒 Installing Cert-Manager for Automated SSL/TLS Certificates..."

# Add Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install Cert-Manager with CRDs
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.0 \
  --set crds.enabled=true

echo "✅ Cert-Manager installed successfully!"
echo "📄 Apply ClusterIssuer and Ingress manifests:"
echo "   kubectl apply -f kubernetes/cert-manager-issuer.yaml"
echo "   kubectl apply -f kubernetes/ingress.yaml"
