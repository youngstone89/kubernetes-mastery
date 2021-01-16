from https://costimuraru.wordpress.com/2018/07/06/deploying-spinnaker-on-minikube-kubernetes-using-hal/

minikube start --cpus 6 --memory 10240

export MINIO_ACCESS_KEY=minio
export MINIO_SECRET_KEY=miniostorage
minio server ~/tmp/minio


hal config storage s3 edit --access-key-id minio --secret-access-key --region us-east-1 --endpoint http://127.0.0.1:9000

hal config storage s3 edit --access-key-id minio --secret-access-key --region us-east-1 --endpoint http://192.168.219.109:9000

## Distributed Minio in Kubernetes
hal config storage s3 edit --access-key-id minio --secret-access-key miniostorage --bucket=spin-bucket --region us-east-1 --endpoint http://minio:9000 --path-style-access=true


hal config storage edit --type s3

hal config provider docker-registry account add dockerhub --address index.docker.io --repositories library/nginx

hal deploy apply

alias spin_gate='kubectl port-forward -n spinnaker $(kubectl get pods -n spinnaker -o=custom-columns=NAME:.metadata.name | grep gate) 8084:8084'

alias spin_deck='kubectl port-forward -n spinnaker $(kubectl get pods -n spinnaker -o=custom-columns=NAME:.metadata.name | grep deck) 9001:9000'

alias spinnaker='spin_gate &; spin_deck &'

spinnaker


hal config security ui edit --override-base-url http://localhost:9001
hal config security api edit --override-base-url http://localhost:8084



# Add DockerHub Repository
ADDRESS=index.docker.io
REPOSITORIES=youngstone89/alpine
hal config provider docker-registry account add dockerhub --address $ADDRESS --repositories $REPOSITORIES


# Edit DockerHub Repository
ADDRESS=index.docker.io
REPOSITORIES=youngstone89/alpine youngstone89/springboot.base.app
hal config provider docker-registry account edit dockerhub --address $ADDRESS --repositories
youngstone89/alpine youngstone89/springboot.base.app


# Content URL 
https://api.github.com/repos/youngstone89/springboot.base.project/contents/helm-chart-0.1.0.tgz




# Optional: Create a Kubernetes Service Account
https://spinnaker.io/setup/install/providers/kubernetes-v2/