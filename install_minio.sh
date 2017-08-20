#!/bin/bash

curl 'https://dl.minio.io/server/minio/release/linux-amd64/minio' > /usr/bin/minio
chmod +x /usr/bin/minio

/usr/bin/minio &
