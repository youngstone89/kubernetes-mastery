#!/usr/bin/env bash

az feature register --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
az feature show --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
az provider register --namespace Microsoft.ContainerService