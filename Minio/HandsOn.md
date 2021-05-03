## Docker Installtaion
docker run -p 9000:9000 minio/minio server /data


## S3/Minio Benchmark tool Installation
## Download from here https://github.com/minio/warp/releases

## Benchmark test with warp
warp mixed --host=localhost:9000 --access-key=minioadmin --secret-key=minioadmin --obj.size=200KiB --concurrent=1 --duration=1m
