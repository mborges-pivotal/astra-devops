# Demo of Astra DevOps APIs in concourse pipeline

Thanks to the [startship-enterprise](https://github.com/michelderu/starship-enterprise) demo created by my colleagues at DataStax for the terraform inspiration. 

Currently there are a lot of assumption about the knowledge required to run this demonstration. We'll improve and add more detail over time. There are 2 parts to this demo: 

1. Terraform script 
1. Astra cql script
1. concourse pipeline

The idea is to use terraform to quickly provision an Astra Database and the cql script to deploye the data model and possibly load data. The concourse pipeline automates the process. 

## Requirements

* [kind](https://kind.sigs.k8s.io/) to run a local kubernetes cluster
* [https://concourse-ci.org/](concourse-ci) used to manage the CI/CD automation
* [https://www.terraform.io/](terraform) for Infrastructure As Code
* [https://registry.terraform.io/providers/datastax/astra/latest](Astra terraform provider)
* Configure terraform to use an [https://www.terraform.io/docs/language/state/remote-state-data.html](remote state data source). You can find details on how to setup the [https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli](terraform state store in Azure storage) link.

### Running Kind
We are using [kind](https://kind.sigs.k8s.io/) to run concourse

```
$ kind create cluster --config kind-config.yaml --name concourse
$ kubectl cluster-info --context kind-concourse
```

### Running Concourse
We are running concourse in the local kind kubernetes cluster

*NOTES:
* Concourse can be accessed:

  * Within your cluster, at the following DNS name at port 8080:

    my-release-web.default.svc.cluster.local

  * From outside the cluster, run these commands in the same shell:

    export POD_NAME=$(kubectl get pods --namespace default -l "app=my-release-web" -o jsonpath="{.items[0].metadata.name}")
    echo "Visit http://127.0.0.1:8080 to use Concourse"
    kubectl port-forward --namespace default $POD_NAME 8080:8080

You can then download the *fly* CLI and create a target for your concourse deployment:
```
$ fly -t local login -c http://127.0.0.1:8080/ -u test -p test
```

## Running Terraform locally
You can run terraform locally, though this current version is configure to use the [azurerm](remote backend).

```
$ export ARM_ACCESS_KEY=YOUR_ACCESS_KEY
$ cd terraform 
$ terraform init
```

## Deploying your pipeline

```
$ export ARM_ACCESS_KEY=YOUR_ACCESS_KEY
$ cd pipeline
$ fly -t local set-pipeline -p astra-devops --config pipeline.yml --var "astra_token=$ASTRA_TOKEN" --var "arm_access_key=$ARM_ACCESS_KEY" --load-vars-from vars.yml
```


