#!/bin/sh

set -e

echo "name: $(cat terraform/name)"
echo "metadata: $(cat terraform/metadata)"

# Get JQ
wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x ./jq

# Download secure bundle
secure_connect_bundle_url=$(cat terraform/metadata | ./jq -r '.secure_connect_bundle_url')
wget -O secure_connect.zip $secure_connect_bundle_url

# Run CQLSH
tar -xzvf concourse/tasks/cqlsh-astra-20201104-bin.tar.gz