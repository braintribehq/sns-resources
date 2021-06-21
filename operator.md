## General info
1. We assume that there is an alias `k=kubectl`
1. We assume admin access to the cluster is configured, you can create needed k8s config using the [aws](https://aws.amazon.com/cli/) tool this way:
```
aws eks update-kubeconfig --name ${clusterName} --kubeconfig ${kubeConfigName}
```

## Deploy Traefik
1. deploy Traefik
```
k apply -f traefik/traefik.yaml
```
2. check deployment
```
k -n kube-system get pods
# has to show traefik-ingress-controller as ready
```

## Deploy the etcd operator
1. deploy the operator
```
k create namespace etcd
k apply -f etcd/rbac.yaml
k apply -f etcd/operator.yaml
k wait deployment/etcd-operator -n etcd --for condition=available
kubectl apply -f etcd/cluster.yaml
```
2. check etcd
```
#check that there is one operator pod and one cluster created
k -n etcd get pods
NAME                             READY   STATUS    RESTARTS   AGE
etcd-operator-75dfcf9fd4-r96f6   1/1     Running   1          1d
tf-etcd-cluster-5rbj4s2jgg       1/1     Running   0          1d
```

## Deploy tfcloud-operator
2. deploy the tfcloud-operator into the namespace `ns`
```
operator/deploy-operator.sh -v -n ns -u docker_user -p docker_pass -e3 -t 0.7.27 -f
```
3. after the command completes you should see 3 etcd pods and tfcloud-operator running in the namespace `ns`:
```
k -n ns get pods
NAME                                READY   STATUS    RESTARTS   AGE
tf-etcd-cluster-fdl2q8qv68          1/1     Running   0          1d
tf-etcd-cluster-m6smxnkrt6          1/1     Running   0          1d
tf-etcd-cluster-rkbfdl8ld8          1/1     Running   0          1d
tfcloud-operator-646dfdbf88-9l4hc   1/1     Running   1          1d
```

## Deploy Tribefire
1. edit your domain name in `runtime.yaml`, use the CNAME you created during cluster setup
1. deploy Tribefire into the namespace where the tfcloud-operator is running
```
k apply -f runtime.yaml 
tribefireruntime.tribefire.cloud/tfdemo-stable created
```
2. check component status
```
k -n ns get pods
NAME                                                      READY   STATUS    RESTARTS   AGE
tf-etcd-cluster-fdl2q8qv68                                1/1     Running   0          1d
tf-etcd-cluster-m6smxnkrt6                                1/1     Running   0          1d
tf-etcd-cluster-rkbfdl8ld8                                1/1     Running   0          1d
tfcloud-operator-646dfdbf88-9l4hc                         1/1     Running   1          1d
tfdemo-stable-postgres-587fc76c94-gt7dp                   1/1     Running   0          1d
tfdemo-stable-tribefire-control-center-58f78ff84f-llphn   1/1     Running   0          1d
tfdemo-stable-tribefire-explorer-fcdff7488-zxqbv          1/1     Running   0          1d
tfdemo-stable-tribefire-master-78f99d77f5-b9nb6           1/1     Running   0          1d
```
 * all pods have to be running and ready
3. connect to the tribefire-master
```
k -n ns get ing
NAME                                     CLASS    HOSTS
tfdemo-stable-tribefire-control-center   <none>   tfdemo-stable-ns.your.domain
tfdemo-stable-tribefire-explorer         <none>   tfdemo-stable-ns.your.domain
tfdemo-stable-tribefire-master           <none>   tfdemo-stable-ns.your.domain
```
 * note that HOST is `tfdemo-stable-ns.your.domain`, connect to `tfdemo-stable-ns.your.domain/services`
4. you should see the landing page, login with the login name provided in the email
