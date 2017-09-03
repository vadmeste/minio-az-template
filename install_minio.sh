#!/bin/bash

LOG_FILE="/tmp/log.txt"

echo "$1" >> $LOG_FILE
echo "$2" >> $LOG_FILE
echo "$3" >> $LOG_FILE
echo "$4" >> $LOG_FILE

mkdir -p $HOME/.minio/certs/
curl "$3" > $HOME/.minio/certs/
curl "$4" > $HOME/.minio/certs/

curl 'https://dl.minio.io/server/minio/release/linux-amd64/minio' > /usr/bin/minio
chmod +x /usr/bin/minio

export MINIO_ACCESS_KEY="$1"
export MINIO_SECRET_KEY="$2"

/usr/bin/minio gateway azure &
