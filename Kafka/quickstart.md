kubectl create namespace kafka
kubectl apply -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka
kubectl apply -f https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml -n kafka 
kubectl wait kafka/my-cluster --for=condition=Ready --timeout=300s -n kafka 


Send and receive messages

Once the cluster is running, you can run a simple producer to send messages to a Kafka topic (the topic will be automatically created):

kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.21.1-kafka-2.7.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic
And to receive them in a different terminal you can run:

kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.21.1-kafka-2.7.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning



kubectl create deployment springboot-kafka --image youngstone89/springboot.base.app:1.0.kafka  -n kafka

kubectl expose deployment springboot-kafka --type NodePort --port 8888 --target-port 8080 -n kafka

kubectl create secret docker-registry regcred --docker-server="https://index.docker.io/v2/" --docker-username="youngstone89" --docker-password="wldndkQk2021**" --docker-email="youngstone89@icloud.com"