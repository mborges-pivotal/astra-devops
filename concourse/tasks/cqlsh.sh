#!/bin/bash

set -e

echo "name: $(cat terraform/name)"
echo "metadata: $(cat terraform/metadata)"

# Get JQ
wget -O $HOME/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x $HOME/jq

# Download secure bundle
secure_connect_bundle_url=$(cat terraform/metadata | $HOME/jq -r '.secure_connect_bundle_url')
wget -O $HOME/secure_connect_bundle.zip $secure_connect_bundle_url

# Install CQLSH for Astra
mv concourse/tasks/ccqlsh-astra-20201104-bin.tar.gz $HOME
cd
tar -xvf ccqlsh-astra-20201104-bin.tar.gz

# Run CQLSH
/usr/share/cqlclient/cqlsh -u $ASTRA_CLIENT_ID -p $ASTRA_CLIENT_SECRET -b $HOME/secure_connect_bundle.zip -f create_model.cql