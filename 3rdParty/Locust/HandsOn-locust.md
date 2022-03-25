## Installing locust 
```
helm repo add deliveryhero https://charts.deliveryhero.io/
helm install deliveryhero/locust
helm install my-release deliveryhero/locust
helm install my-release deliveryhero/locust --set values_key1=value1 --set values_key2=value2
helm install my-release deliveryhero/locust -f values.yaml
```

## provide your own custom locustfile
```
kubectl create configmap my-loadtest-locustfile --from-file path/to/your/main.py
kubectl create configmap my-loadtest-lib --from-file path/to/your/lib/
```

## installing chart passing the names of configmaps
```
helm install locust deliveryhero/locust \
  --set loadtest.name=my-loadtest \
  --set loadtest.locust_locustfile_configmap=my-loadtest-locustfile \
  --set loadtest.locust_lib_configmap=my-loadtest-lib
```