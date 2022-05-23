#!/usr/bin/env bash
$ grpcurl grpc-test.eastus.cloudapp.azure.com:443 helloworld.Greeter/SayHello
{
  "message": "Hello "
}