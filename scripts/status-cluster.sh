#!/bin/bash
# ============================================================
# Script : status-cluster.sh
# Description : Affiche l'état complet du cluster AKS
# ============================================================

echo "======================================"
echo "  STATUT DU CLUSTER AKS voting-app"
echo "======================================"

echo ""
echo "--- NOEUDS ---"
kubectl get nodes -o wide

echo ""
echo "--- RELEASES HELM ---"
helm list -A

echo ""
echo "--- PODS (tous namespaces) ---"
kubectl get pods -A

echo ""
echo "--- SERVICES ---"
kubectl get svc -A

echo ""
echo "--- INGRESS ---"
kubectl get ingress -A

echo ""
echo "--- IP PUBLIQUE DE L'APPLICATION ---"
IP=$(kubectl get svc azure-vote-azure-vote-chart -n voting-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
if [ -n "$IP" ]; then
  echo "Application accessible sur : http://$IP"
else
  echo "IP publique non disponible"
fi
