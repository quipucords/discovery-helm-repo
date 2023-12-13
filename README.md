# Discovery Helm Chart Repository

This Helm repository contains the helm charts for the RedHat Discovery product.

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
