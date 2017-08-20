#!/bin/bash

curl 'https://dl.minio.io/server/minio/release/linux-amd64/minio' > /usr/bin/minio
chmod +x /usr/bin/minio

export MINIO_ACCESS_KEY="$1"
export MINIO_SECRET_KEY="$2"

/usr/bin/minio gateway azure &
