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
# Create a policy 
vault write auth/approle/role/my-role --secret_id_ttl=10m --token_num_uses=10 --token_ttl=20m --token_max_ttl=30m --secret_id_num_uses=40
# Role-ID&Secret-ID value to be used later
vault read auth/approle/role/my-role/role-id
vault write -f auth/approle/role/my-role/secret-id

# Argocd
kubectl apply -f argocd.yaml -n argocd
kubectl port-forward argocd-server 8080:8080 -n argocd &
kubectl.exe -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
