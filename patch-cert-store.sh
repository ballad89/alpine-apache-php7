#!/bin/bash

set -e

mydir=/tmp

curl -sS "https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem" > ${mydir}/rds-combined-ca-bundle.pem
awk 'split_after == 1 {n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1}{print > "rds-ca-" n ".pem"}' < ${mydir}/rds-combined-ca-bundle.pem

mkdir /usr/local/share/ca-certificates/aws

mv rds-ca-* /usr/local/share/ca-certificates/aws

for CERT in /usr/local/share/ca-certificates/aws/rds-ca-*; do
  openssl x509 -in $CERT -inform PEM -out ${CERT}.crt
done

update-ca-certificates
