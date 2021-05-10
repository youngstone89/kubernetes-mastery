# Install 
helm install grafana grafana/grafana \
    --namespace monitoring \
    --set persistence.storageClassName="standard" \
    --set persistence.enabled=true \
    --set adminPassword='EKS!sAWSome' \
    --values environment/grafana/grafana.yaml \
    --set service.type=LoadBalancer

>
NAME: grafana
LAST DEPLOYED: Mon May 10 14:59:53 2021
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:

   kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

   grafana.monitoring.svc.cluster.local

   Get the Grafana URL to visit by running these commands in the same shell:
NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        You can watch the status of by running 'kubectl get svc --namespace monitoring -w grafana'
     export SERVICE_IP=$(kubectl get svc --namespace monitoring grafana -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
     http://$SERVICE_IP:80

3. Login with the password from step 1 and the username: admin