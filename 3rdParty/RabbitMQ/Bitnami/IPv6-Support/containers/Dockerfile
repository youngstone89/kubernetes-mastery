FROM busybox AS base
RUN mkdir -p /scripts
COPY scripts/setup.sh /scripts
WORKDIR /scripts
RUN chmod +x setup.sh
RUN ./setup.sh

FROM docker.io/bitnami/rabbitmq:3.9 
COPY --from=base /tmp/ipv6-cfg/erl_inetrc /tmp/ipv6-cfg/erl_inetrc
# ENV RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS=-kernel\ inetrc\ '/tmp/ipv6-cfg/erl_inetrc'\ -proto_dist\ inet6_tcp
# ENV RABBITMQ_CTL_ERL_ARGS=-proto_dist\ inet6_tcp

