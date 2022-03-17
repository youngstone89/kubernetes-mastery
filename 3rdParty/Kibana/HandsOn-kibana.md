```
helm repo add elastic https://helm.elastic.co
```
```
helm install kibana -f values-kibana.yaml --version 7.16.2 elastic/kibana -n nuance-analytics 
```