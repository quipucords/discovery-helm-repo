# Discovery Helm Chart Repository

This Helm repository contains the helm charts for the RedHat Discovery product.

## Installing Discovery using the OpenShift UI
This repo can be used for deploying Discovery using the OpenShift Console UI. Once configured in OpenShift, it will show up as a Chart Repository as follows:

```
Chart Repositories
 [ ] OpenShift Helm Charts(78)
 [ ] Discovery Helm Charts(1)
```

The repository serves its files directly from github via GitHub Pages at the [https://quipucords.github.io/discovery-helm-repo/charts](https://quipucords.github.io/discovery-helm-repo) location with the current Chart index [https://quipucords.github.io/discovery-helm-repo/charts/index.yaml](https://quipucords.github.io/discovery-helm-repo/charts/index.yaml)

To add the repository to OpenShift, first `oc login` to your Cluster as kubeadmin, then run the following command from a checked out repo:

```
$ oc create -f templates/discovery_charts_repo.yaml
```

or directly from GitHub Pages as follows:

```
$ oc create -f https://quipucords.github.io/discovery-helm-repo/templates/discovery_charts_repo.yaml
```

Within a minute or so then the Discovery Helm Chart will appear in the OpenShift Developer Catalog. You can access the Discovery Helm Chart from the Developer Console, clicking `Add` -> `Helm Chart` then typing `disc` in the Filter for a search, or simply select the `Discovery Helm Charts` repository.

## Installing Discovery using the Helm CLI
Altenatively, one can download a specific version of the Helm Chart from this repo and install Discovery by using the Helm CLI.


First, login to the OpenShift cluster and create a project for running discovery. For these examples we will use `discovery-qe`:

```
$ oc login https://api.<your_cluster>:6443 -u kubeadmin -p <kubeadmin_password>
$ oc new-project discovery-qe
```

Next, make sure the Helm CLI is installed:

On Mac:

```
$ brew install helm
```

For all others, please visit [https://helm.sh/docs/intro/install/]()

For downloading the Discovery image, you need to create a `discovery-pull-secret` that has the credentials needed to access `registry.redhat.io`. The secret can be created using `oc create secret ...` or by using the helper script provided here:

```
$ mkdir ~/bin
$ curl -k https://quipucords.github.io/discovery-helm-repo/bin/create_pull_secret.sh \
      --output ~/bin/create_pull_secret.sh
$ chmod 755 ~/bin/create_pull_secret.sh
$ create_pull_secret.sh "discovery-pull-secret"

Registry server - registry.redhat.io:
Registry username - <user>: <user-email>
Registry password: ....
Registry user e-mail - <user-email>:

Add another docker server (y/n)?n
Creating pull secret discovery-pull-secret ...
secret/discovery-pull-secret created
$ 
```


Next, look at the chart index in this repo to determine which helm chart version to download.
In [Chart Index](https://quipucords.github.io/discovery-helm-repo/charts/index.yaml), find the Helm Chart `version` that reflects the desired `appVersion` of Discovery.

For example, you can see Helm Chart version `0.9.2` pulls in Discovery `1.5.3`.

Then download the appropriate 

```
$ mkdir -p ~/discovery-helm
$ cd ~/discovery-helm
$ curl -k https://quipucords.github.io/discovery-helm-repo/charts/discovery-0.9.2.tgz \
    --output discovery-0.9.2.tgz
$ tar -xzf discovery-0.9.2.tgz
$ ls -FC
discovery/    discovery-0.9.2.tgz
```

The downloaded and extracted Discovery helm chart 0.9.2 will be in the `discovery` directory

Finally, install discovery using the Helm CLI:

```
$ helm install discovery ./discovery --set server.password="EXAMPLE-superadmin1"
NAME: discovery
LAST DEPLOYED: Sun Mar  7 16:09:56 2024
NAMESPACE: discovery-qe
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES: ...
```

To uninstall the above release of discovery:

```
$ helm uninstall discovery
release "discovery" uninstalled
```

Note that `helm list` will show the installed Charts in the namespace:

```
$ helm list
NAME               NAMESPACE        REVISION    UPDATED                                 STATUS      CHART         	  APP VERSION
discovery          discovery-qe     1           2024-03-07 12:11:07.898808 -0500 EST    deployed    discovery-0.9.2   1.5.3
```


