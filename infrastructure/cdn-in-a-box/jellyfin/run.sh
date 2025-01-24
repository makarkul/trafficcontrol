#!/usr/bin/env bash

set -e
set -x
set -m

bash

chmod +x /usr/local/sbin/insert-any-into-dns.sh
set-dns.sh
insert-self-into-dns.sh
for hn in $HOSTNAMES4DNSENTRY; do
   insert-any-into-dns.sh ${hn,,}
done

source /to-access.sh

# Wait on SSL certificate generation
until [[ -f "$X509_CA_ENV_FILE" ]]
do
     echo "Waiting on Shared SSL certificate generation"
     sleep 3
done

# Source the CIAB-CA shared SSL environment
until [[ -n "$X509_GENERATION_COMPLETE" ]]
do
  echo "Waiting on X509 vars to be defined"
  sleep 1
  source "$X509_CA_ENV_FILE"
done

# Copy the CIAB-CA certificate to the traffic_router conf so it can be added to the trust store
cp $X509_CA_CERT_FULL_CHAIN_FILE /usr/local/share/ca-certificates
update-ca-certificates

while ! to-ping 2>/dev/null; do
  echo "waiting for Traffic Ops"
  sleep 3
done

# Enroll the Origin because it is used in a Multi-Site Origin Delivery Service.
to-enroll origin "$CDN_NAME" 'CDN_in_a_Box_Jellyfin' || (while true; do echo "enroll failed."; sleep 3 ; done)

/jellyfin/jellyfin

