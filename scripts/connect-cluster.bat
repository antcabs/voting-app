@echo off
REM ============================================================
REM Script : connect-cluster.bat
REM Description : Connexion au cluster AKS voting-app (Windows)
REM ============================================================

set RESOURCE_GROUP=rg-voting-app-sc
set CLUSTER_NAME=aks-voting-app

echo Connexion a Azure...
az login

echo.
echo Recuperation des credentials kubectl...
az aks get-credentials --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME% --overwrite-existing

echo.
echo Verification de la connexion :
kubectl get nodes

echo.
echo Connexion reussie !
pause
