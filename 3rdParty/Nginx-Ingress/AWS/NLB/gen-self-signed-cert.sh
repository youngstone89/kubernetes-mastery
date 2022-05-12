#!/usr/bin/env bash

# generate certificate and private key
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout
tls.key -out tls.crt -subj "/CN=anthonycornell.com/O=anthonycornell.com"

# create the secret in the cluster
kubectl create secret tls tls-secret --key tls.key --cert tls.crt