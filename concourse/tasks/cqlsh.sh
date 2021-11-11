#!/bin/bash

set -e

echo "name: $(cat terraform/name)"
echo "metadata: $(cat terraform/metadata)"

secure_connect_bundle_url=$(cat terraform/metadata | ./jq -r '.secure_connect_bundle_url')

wget -O secure_connect.zip $secure_connect_bundle_url

tar -xzvf concourse/tasks/cqlsh-astra-20201104-bin.tar.gz