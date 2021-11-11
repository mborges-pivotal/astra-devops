# Demo of Astra DevOps APIs in concourse pipeline

Thanks to the [startship-enterprise](https://github.com/michelderu/starship-enterprise) demo created by my colleagues at DataStax for the terraform inspiration. 

Using kind to run concourse CI/CD

* kubectl cluster-info --context kind-concourse

## Requirements

* [https://concourse-ci.org/](concourse-ci) used to manage the CI/CD automation
* Configure terraform to use an [https://www.terraform.io/docs/language/state/remote-state-data.html](remote state data source)

## Astra Terraform Provider
* https://registry.terraform.io/providers/datastax/astra/latest

## Running Concourse
*NOTES:
* Concourse can be accessed:

  * Within your cluster, at the following DNS name at port 8080:

    my-release-web.default.svc.cluster.local

  * From outside the cluster, run these commands in the same shell:

    export POD_NAME=$(kubectl get pods --namespace default -l "app=my-release-web" -o jsonpath="{.items[0].metadata.name}")
    echo "Visit http://127.0.0.1:8080 to use Concourse"
    kubectl port-forward --namespace default $POD_NAME 8080:8080

