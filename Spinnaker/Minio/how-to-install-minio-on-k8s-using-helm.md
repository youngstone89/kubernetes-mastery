#  https://github.com/minio/charts#configuration
## Configure MiniO Helm repo
helm repo add minio https://helm.min.io/
## Install with default config
helm install --namespace minio --generate-name minio/minio

## Install with release name
helm install minio --set accessKey=minio,secretKey=miniostorage  --namespace spinnaker  minio/minio

## Override Access and Secret Keys
helm install --set accessKey=myaccesskey,secretKey=mysecretkey --generate-name minio/minio