#!/bin/bash

LOG_FILE="/tmp/log.txt"

MINIO_USER="$1"
MINIO_ACCESS_KEY="$2"
MINIO_SECRET_KEY="$3"
PUBLIC_CERT_BLOB="$4"
PRIVATE_CERT_BLOB="$5"

HOME="/home/$MINIO_USER"

MINIO_BINARY=/usr/local/bin/minio
SYSTEMD_CONFDIR=/etc/systemd/system/
SYSTEMD_MINIO=https://raw.githubusercontent.com/vadmeste/minio-az-template/minio_ssl_systemd/minio.service 


cat <<EOT > /etc/default/minio
# Use if you want to run Minio on a custom port.
MINIO_OPTS="--address :9000"
EOT

cat <<EOT >> /etc/default/minio
# Access Key of the server.
MINIO_ACCESS_KEY="$MINIO_ACCESS_KEY"
# Secret key of the server.
MINIO_SECRET_KEY="$MINIO_SECRET_KEY"

EOT

mkdir -p $HOME/.minio/certs/
if [ ! -z "$PUBLIC_CERT_BLOB" -o ! -z "$PRIVATE_CERT_BLOB" ]; then
    echo "$PUBLIC_CERT_BLOB" | base64 -d > $HOME/.minio/certs/public.crt
    echo "$PRIVATE_CERT_BLOB" | base64 -d > $HOME/.minio/certs/private.key
fi

chown -R $MINIO_USER:$MINIO_USER $HOME/.minio/

curl 'https://dl.minio.io/server/minio/release/linux-amd64/minio' > $MINIO_BINARY
chmod +x $MINIO_BINARY

curl $SYSTEMD_MINIO > $SYSTEMD_CONFDIR/minio.service

sed -i "s#User=minio-user#User=$MINIO_USER#" $SYSTEMD_CONFDIR/minio.service
sed -i "s#Group=minio-user#Group=$MINIO_USER#" $SYSTEMD_CONFDIR/minio.service

systemctl enable minio.service
systemctl start minio.service

