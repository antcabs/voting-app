@echo off
REM ============================================================
REM Script : status-cluster.bat
REM Description : Affiche l'etat complet du cluster AKS (Windows)
REM ============================================================

echo ======================================
echo   STATUT DU CLUSTER AKS voting-app
echo ======================================

echo.
echo --- NOEUDS ---
kubectl get nodes -o wide

echo.
echo --- RELEASES HELM ---
helm list -A

echo.
echo --- PODS (tous namespaces) ---
kubectl get pods -A

echo.
echo --- SERVICES ---
kubectl get svc -A

echo.
echo --- INGRESS ---
kubectl get ingress -A

echo.
echo --- IP PUBLIQUE DE L'APPLICATION ---
kubectl get svc azure-vote-azure-vote-chart -n voting-app

pause
