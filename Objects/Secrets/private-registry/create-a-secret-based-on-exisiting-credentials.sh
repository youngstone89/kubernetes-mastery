#!/usr/bin/env bash
docker login
cat ~/.docker/config.json
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/Users/yeongseokkim/.docker/config.json/.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson \
    --dry-run=client

kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=
