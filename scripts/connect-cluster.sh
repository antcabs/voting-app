#!/bin/bash
# ============================================================
# Script : connect-cluster.sh
# Description : Connexion au cluster AKS voting-app
# ============================================================

RESOURCE_GROUP="rg-voting-app-sc"
CLUSTER_NAME="aks-voting-app"

echo "Connexion à Azure..."
az login

echo ""
echo "Récupération des credentials kubectl pour le cluster $CLUSTER_NAME..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

echo ""
echo "Vérification de la connexion au cluster :"
kubectl get nodes

echo ""
echo "Connexion réussie ! Vous pouvez maintenant utiliser kubectl."
