#!/bin/bash
# ============================================================
# Script : deploy.sh
# Description : Déploie ou met à jour l'application via Helm
# ============================================================

NAMESPACE="voting-app"
CHART_PATH="./azure-vote-chart"

echo "======================================"
echo "  DÉPLOIEMENT Azure Vote App"
echo "======================================"

# Vérifier si le namespace existe
kubectl get namespace $NAMESPACE &>/dev/null || kubectl create namespace $NAMESPACE

# Vérifier si la release existe déjà
if helm status azure-vote -n $NAMESPACE &>/dev/null; then
  echo "Mise à jour de la release azure-vote..."
  helm upgrade azure-vote $CHART_PATH --namespace $NAMESPACE
else
  echo "Installation de la release azure-vote..."
  helm install azure-vote $CHART_PATH --namespace $NAMESPACE
fi

echo ""
echo "Attente du démarrage des pods..."
kubectl rollout status deployment/azure-vote-azure-vote-chart -n $NAMESPACE --timeout=120s

echo ""
echo "--- PODS ---"
kubectl get pods -n $NAMESPACE

echo ""
IP=$(kubectl get svc azure-vote-azure-vote-chart -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
if [ -n "$IP" ]; then
  echo "Application accessible sur : http://$IP"
fi
