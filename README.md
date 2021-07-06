# Deploy Portworx Enterprise on vSphere with Tanzu - PhotonOS

With the introduction of vSphere with Tanzu, Pure Storage has provided support with vVols for persistent storage.

Since acquiring Portworx in the fall of 2020, the need to extend the current Pure Validated Design to include the Portworx Data Services platform has been in demand. 

**The instructions found here are for clusters based on PhotonOS.**

## To deploy a Portworx enabled Tanzu cluster (TKGs)
1. Enable Workload Management according to VMware Best Practices:[VMware vSphere with Tanzu Workflow](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-3040E41B-8A54-4D23-8796-A123E7CAE3BA.html)
2. To deploy a Portworx Enabled Cluster, open [tanzu-cluster/cluster-admin-psp-command.sh](https://github.com/cjkennedy1972/px-azurearc-dataservices/blob/master/tanzu-cluster/cluster-admin-psp-command.sh) and paste the command into your terminal window where you run kubectl commands
3. Create 2 new VM Classes and assign them to your namespace in the vSphere UI
   1. tkg-control-plane- 4 vCPUs and 4Gi RAM
   2. tkg-workers - 8 vCPUs and 16 or 32Gi RAM
4. Make sure all pre-requisites are met based on VMware documentation.
5. Edit [tanzu-cluster/tkg-cluster-conf.yaml](https://raw.githubusercontent.com/cjkennedy1972/px-azurearc-dataservices/master/tanzu-cluster/tkc-cluster-conf.yaml) to use the Storage Classes you have configured and make sure the namespace is accurate and save it to your management station.
6. Apply the [tanzu-cluster/tkg-cluster-conf.yaml](https://raw.githubusercontent.com/cjkennedy1972/px-azurearc-dataservices/master/tanzu-cluster/tkc-cluster-conf.yaml) file to your namespace to create a cluster
7. Follow VMware guides to connect to the Tanzu cluster with kubectl command:[Connect to Tanzu Cluster](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-AA3CA6DC-D4EE-47C3-94D9-53D680E43B60.html)
8. Once cluster is available, open [portworx-tanzu/portworx-psp.sh](https://github.com/cjkennedy1972/px-azurearc-dataservices/tree/master/portworx-tanzu/portworx-psp.sh) and paste the command into your terminal to grant serviceaccounts in the kube-system namespace permissions to run privileged pods.
9. To deploy the Portworx Operator into the kube-system namespace, apply [portworx-tanzu/tkc-px-operator.yaml](https://raw.githubusercontent.com/cjkennedy1972/px-azurearc-dataservices/master/portworx-tanzu/tkc-px-operator.yaml)
10. Once the operator is running, apply [portworx-tanzu/tkc-px-cluster.yaml](https://raw.githubusercontent.com/cjkennedy1972/px-azurearc-dataservices/master/portworx-tanzu/tkc-px-cluster.yaml), this will deploy the Portworx Storage Cluster
11. Watch the pods using `watch kubectl get pods -n kube-system -l name=portworx`
12. When the pods reach 2/3 running, stop the watch process, or open a second terminal and open [portworx-tanzu/portworx-firewall-psp.sh](https://github.com/cjkennedy1972/px-azurearc-dataservices/blob/master/portworx-tanzu/portworx-firewall-psp.sh) and paste the contents into your active terminal
13. Once this command is issued, the cluster will finish deploying. This usually takes between 5-10 minutes.

**The deployment will use the vsphere-csi driver to configure a Portworx Storage Pool**
