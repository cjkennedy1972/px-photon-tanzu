
kubectl create rolebinding portworx-cluster-rolebinding --namespace=kube-system\
 --clusterrole=psp:vmware-system-privileged --group=system:serviceaccounts &&\
 kubectl get pods -n kube-system -l name=portworx |cut -f1 -d\  |\
while read pod; \
 do echo "$pod setting host firewall rules:";\
  kubectl exec -t $pod -n kube-system -- nsenter --mount=/host_proc/1/ns/mnt bash -c \
   "iptables -A INPUT -p tcp --match multiport --dports 9001:9020 -j ACCEPT && iptables -A INPUT -p tcp --match multiport --dports 1970 -j ACCEPT"
done
