#!/usr/bin/env bash

helm upgrade --install rabbitmq rabbitmq/  -f override/values.yaml -n analytics-ys

