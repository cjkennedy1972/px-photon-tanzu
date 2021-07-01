kubectl create rolebinding portworx-cluster-rolebinding --namespace=kube-system\
 --clusterrole=psp:vmware-system-privileged --group=system:serviceaccounts