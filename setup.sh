APP="masaratapp"
CLUSTER="masaratapp"
APPPORT="8081"
NAMESPACE="masaratapp"

# k3d setup
k3d cluster create  $CLUSTER   -p "$APPPORT:80@loadbalancer" --agents 1


# argocd setup namespace
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# app setup namespace
kubectl create namespace $NAMESPACE

echo "\033[33mWaiting for argoCD to start...\033[0m"
# containers pulling taking time
sleep 60 


# expose argocd ui to port 8000
kubectl port-forward -n argocd svc/argocd-server 8000:443   > /dev/null 2>&1 &


# argocd password 
PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"  | base64 -d; echo)
argocd login localhost:8000  --username admin --password $PASSWORD --insecure
echo "PASSWORD: " $PASSWORD
argocd app create $APP --repo https://github.com/yssefnoam/masaratApp.git --path ./kubernetes/ --dest-server https://kubernetes.default.svc --dest-namespace $NAMESPACE

argocd app set $APP --sync-policy automated
