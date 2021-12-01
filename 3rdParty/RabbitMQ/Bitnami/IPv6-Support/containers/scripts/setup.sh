#!/bin/sh
mkdir -p /tmp/ipv6-cfg/ 
echo "{inet6, true}." > /tmp/ipv6-cfg/erl_inetrc
cat /tmp/ipv6-cfg/erl_inetrc

