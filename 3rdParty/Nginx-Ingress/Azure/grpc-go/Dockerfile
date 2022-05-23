FROM golang:buster as build

WORKDIR /go/src/grpc-go

COPY src/main.go .
RUN mkdir helloworld
COPY src/helloworld helloworld

RUN go mod init grpc-go && \
  go mod tidy && \
  go mod vendor && \
  go build -o /greeter-server main.go

FROM gcr.io/distroless/base-debian10

COPY --from=build /greeter-server /

EXPOSE 50051

CMD ["/greeter-server"]
