
Installing RabbitMQ Cluster Operator in a Kubernetes Cluster

Overview

This guide covers the installation of the RabbitMQ Cluster Kubernetes Operator in a Kubernetes cluster.

Compatibility

The Operator requires

Kubernetes 1.18 or above
RabbitMQ DockerHub image 3.8.8+
Installation

To install the Operator, run the following command:

```
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
```



Installation using Helm chart

To install the Operator using Bitnami Helm chart, run the following command:
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install rabbitmq-cluster-operator bitnami/rabbitmq-cluster-operator
```



```
kubectl krew install rabbitmq
```