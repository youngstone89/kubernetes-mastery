kubectl create deployment helloworld --image tomaustin/helloworldnetcore
kubectl expose deployment helloworld --name helloworld --port 80
