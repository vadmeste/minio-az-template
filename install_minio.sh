#!/bin/bash

MINIO_CERT_DIR=/root/.minio/certs/

curl 'https://dl.minio.io/server/minio/release/linux-amd64/minio' > /usr/bin/minio
chmod +x /usr/bin/minio

mkdir -p $MINIO_CERT_DIR
curl "$3" > $MINIO_CERT_DIR/public.crt
curl "$4" > $MINIO_CERT_DIR/private.key

export MINIO_ACCESS_KEY="$1"
export MINIO_SECRET_KEY="$2"

/usr/bin/minio gateway azure &
