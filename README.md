# GitOps-Vault
after you set up vault, you need to update the configuration of your argocd to download & register the used plugin "AVP" either:
- using initContainer to download the plugin 
- building a new image for argocd repo server

in both way, you have to edit the argocd-cm with the default plugin command to run.

# Notes:
- `AVP` prefix is super important! :rotating_light::fire:
![Image 1](image/avp-prefix.png)
- if your vault in same cluster, then the address is : `http://SERVICENAME.NAMESPACE.svc:PORT`, otherwise the plugin will not work! :zap:
![Image 2](image/address.png)
- set the write permissions and path in the attached policy, otherwise you will get a permission denied issue! :stop_sign:
didn't take a screenshot :( :grimacing:, so ...
- make sure of the secret id ttl, if you are not an expert with vault, I recommand leaving it default way!:vertical_traffic_light:
- using vault http api from inside a pod where vault deployed is super useful way of debugging!:construction:

# implementation:

## preparation
To manage secrets using Vault plugin in GitOps:

### Updating k8s secret file with:
1. Add annotation with the secret path in vault ( there is another way to do so, you can find it [here](https://github.com/IBM/argocd-vault-plugin#how-it-works))
2. Replace the secret value with `<KEY-NAME>`, by encoding it this way, the plugin will recognize it and replace it with the real value

![Image 3](image/secret-yaml.png)

you can find it [here](https://github.com/saloyiana/demo)

### Argocd 
You need to select the plugin while creating the application whether using the UI or YAML:

![Image 4](image/argocd-plugin.png)

## Tool Result:

- creating an application with the plugin in Argocd, after it deployed:
![Image 5](image/argocd.png)

and that is all!! :woman_juggling:

### Verifying if it is working as expected

Get the secret value in k8s :innocent:
![Image 6](image/secret-value.png)

decode it :thinking:
![Image 7](image/decoded-secret.png)

what is the stored value in vault? :raised_eyebrow:
![Image 8](image/vault.png)

Yeah :smirk:

### Updating Secret Value in Vault

After Creating a new vesion of the secret in Vault

Depending on the Sync policy of Argocd application

![Image 9](image/argocd-updated.png)

after syncing, Check the secret 
![Image 10](image/secret-updated.png)

Updated value in Vault 
![Image 11](image/vault-updated.png)


# Quick Compersion Between Secret Management Tools used GitOps: 

| Sealed Secret | AVP           |
| ------------- | ------------- |
| Deals with Secret Object Only  | Deals with all k8s Object as long as it has avp annotation  |
| Easy setup | Needs more steps  |
| who has access to both git and k8s cluster can see the secret's value | the secret stored in Vault, therefore you need access to it to access secret's vaule 


