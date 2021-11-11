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

task_dir=$PWD

# Install CQLSH for Astra
cp pipeline/concourse/tasks/cqlsh-astra-20201104-bin.tar.gz $HOME
cd
tar -xvf cqlsh-astra-20201104-bin.tar.gz

# Run CQLSH
cqlsh-astra/bin/cqlsh -u $ASTRA_CLIENT_ID -p $ASTRA_CLIENT_SECRET -b $HOME/secure_connect_bundle.zip -f ${task_dir}/pipeline/concourse/tasks/create_model.cql