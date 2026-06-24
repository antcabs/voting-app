#!/bin/bash
# ============================================================
# Script : cleanup.sh
# Description : Supprime les releases Helm et les namespaces
#               (NE supprime PAS le cluster AKS)
# ============================================================

echo "======================================"
echo "  NETTOYAGE DES DÉPLOIEMENTS"
echo "======================================"
echo ""
echo "ATTENTION : Cette action va supprimer toutes les releases Helm."
read -p "Êtes-vous sûr ? (oui/non) : " CONFIRM

if [ "$CONFIRM" != "oui" ]; then
  echo "Annulé."
  exit 0
fi

echo ""
echo "Suppression de azure-vote..."
helm uninstall azure-vote -n voting-app 2>/dev/null && echo "OK" || echo "Déjà supprimé"

echo "Suppression de redis..."
helm uninstall redis -n voting-app 2>/dev/null && echo "OK" || echo "Déjà supprimé"

echo "Suppression de ingress-nginx..."
helm uninstall ingress-nginx -n ingress-nginx 2>/dev/null && echo "OK" || echo "Déjà supprimé"

echo "Suppression de kubecost..."
helm uninstall kubecost -n kubecost 2>/dev/null && echo "OK" || echo "Déjà supprimé"

echo ""
echo "Suppression des namespaces..."
kubectl delete namespace voting-app 2>/dev/null
kubectl delete namespace ingress-nginx 2>/dev/null
kubectl delete namespace kubecost 2>/dev/null

echo ""
echo "Nettoyage terminé."
