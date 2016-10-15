## Security

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

## Ansible

```sh
ansible all -m ping # ping all machines
# --private-key (location to ssh private key between provider and local machine)
```

###Inventory
Ansible uses inventory files to map names to machine addresses.

```sh
// example
[web]

192.0.0.1
192.0.0.2
```

Now in playbooks you can target hosts by name.

```yml
---
- hosts: web
```


###Dynamic Inventory

Terraform has information regarding names and addresses in tfstate file. Using a script you can parse the tfstate file and pass it into ansible as a dynamic inventory.

```sh
brew install terraform-inventory
```

This script will help parse tfstate file and generate an inventory file to use with ansible, you can use it by using the `-i` flag

```sh
ansible -i $(which terraform-inventory) all -m ping

ansible-playbook --inventory-file=$(which terraform-inventory) playbooks/foo.yml -u root
```

### Ansible Template Variables

```sh
hostvars # map of all hosts information keyed by hostnames
inventory_hostname # current machine's hostname eg. hostvars[inventory_hostname]
groups # map of all hosts keyed by group names
```

Templating syntax

```python
{% set ips=[] %}
{% for host in groups['etcd'] %}
  {% if ips.insert(loop.index, hostvars[host]['ipv4_address']) %}
  {% endif %}
{% endfor %}

# ips is now an array
{{ips|join(',')}}
```