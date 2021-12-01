#!/usr/bin/env bash

az login 
az acr login -n psxaasstackacr
docker push psxaasstackacr.azurecr.io/mob-ps/dev/rabbitmq-ipv6:latest


