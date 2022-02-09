minikube addons enable ingress
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment web --type=NodePort --port=8080
minikube service web --url

k delete -A ValidatingWebhookConfiguration ingress-nginx-admission 
minikube ip

kubectl create deployment web2 --image=gcr.io/google-samples/hello-app:2.0