helm repo add datadog https://helm.datadoghq.com
helm repo add stable https://charts.helm.sh/stable


helm install datadog -f values.yaml  --set datadog.apiKey= datadog/datadog --set targetSystem=linux
	