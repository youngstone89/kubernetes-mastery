# Cheatsheet
## List all objects created in cluster.
`kubectl get all`
## Detele all objects created in cluster. 
`kubectl delete all --all --all-namespaces`


## Create a Pod Object using Standard Input 
`cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: redis
spec:
  containers:
    - name: redis-container
      image: redis123
EOF`

## Scale ReplicaSet
Option1) `kubectl replace -f replicaset-scale.yaml`  
Option2) `kubectl scale --replicas=6 -f replicaset.yaml`  
Option3) `kubectl scale --replicas=6 replicaset myapp-replicaset`  


## Scaffolding manifest files. 
`kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run=client -o yaml`  
`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml`

## set dev namespace as active context for the current context I am interacting in
`kubectl config set-context $(kubectl config current-context) --namespace=dev`

## Deployments
### Imperative Create
`kubectl run nginx --image=nginx  --dry-run=client -o yaml`  
`kubectl create deployment --image=nginx nginx`  
`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml`  
`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml`  


## Services
### Imperative  Create
`kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml`  
`kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml`  
`kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml`  
`kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml`  

## ConfigMaps
### Imperative  Create
` kubectl create configmap \
app-config --from-literal=APP_COLOR=blue \
           --from-literal=APP_MOD=prod `
` kubectl create configmap \
app-config --from-file=app_config.properties`

## Secrets
### Imperative  Create
` kubectl create secret generic \
app-secret --from-literal=DB_HOST=mysql \
           --from-literal=DB_USER=root  \
           --from-literal=DB_PASSWD=passrd `








## Taints
`kubectl taint nodes node1 key=value:NoSchedule`
`kubectl taint nodes ip-192-168-240-76.ec2.internal lifecycle=od:NoSchedule`


## ClusterRoles 
`kubectl create clusterrole foo --verb=get,list,watch --resource=rs.extensions --dry-run=client -o yaml > cr.yaml`

## ClusterRoleBinding
`kubectl create clusterrolebinding foo --clusterrole=foo --user=bar --dry-run=client -o yaml > crb.yaml`


## api-groups
`kubectl api-resources`


## Service Ingress
`kubectl expose deployment -n ingress-space ingress-controller --type=NodePort --port=80 --name=ingress --dry-run -o yaml >ingress.yaml`