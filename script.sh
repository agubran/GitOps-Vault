#!bin/bash
# Install helm
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault
kubectl port-forward vault-0 8200:8200 &
# To get the key threshold 
kubectl exec -ti vault-0 -- vault operator init
# Unseal them
kubectl exec -ti vault-0 -- vault operator unseal # ... Unseal Key n
# Configer Approle
vault login
vault auth enable approle
# Create a policy named argocd
vault write auth/approle/role/my-role token_policies="argocd" token_ttl=20m token_max_ttl=30m
# Role-ID&Secret-ID value to be used later
vault read auth/approle/role/my-role/role-id
vault write -f auth/approle/role/my-role/secret-id

# Argocd
kubectl apply -f argocd.yaml -n argocd
kubectl port-forward argocd-server 8080:8080 -n argocd &
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
