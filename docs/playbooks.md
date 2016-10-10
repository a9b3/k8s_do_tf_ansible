### Security

Use a CA to sign certs for all services. Each module will be transfered the CA and CA private key to then sign the keys with (it would be better if signing happens in one place instead of passing the CA and CA private key). This happens in `generate-certs.sh` which is a script that is passed into each module. Check out the playbook.

### kube-apiserver etcd issue

To connect to etcd through tls you must pass in additional flags when starting kube-apiserver. This is already done in the playbook provided, just a note because most tutorials online do not include this.

```sh
kube-apiserver \
  --etcd-cafile={{ca.pem}} \
  --etcd-certfile={{certfile}} \
  --etcd-keyfile={{keyfile}} \
  # ...
```

Another issue, when using TLS to connect to etcd cluster from api server, `kubectl get componentstatuses` returns unhealthy for etcd nodes even though they are healthy.

https://github.com/kubernetes/kubernetes/issues/29330

### kube

#### controller

- apiserver
- controller manager
- scheduler

#### worker

- kubelet
- proxy
