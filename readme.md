## Prereqs

Dynamic inventory script for terraform. Need this for getting host ips from terraform state for use with ansible.

```sh
brew install terraform-inventory
```

#### Env Vars

Terraform digitalocean provider needs a valid digitalocean token, and each node requires ssh fingerprint so ansible can ssh into each machine to do it's thing.

- `DO_TOKEN` [tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2)<br>
- `DO_SSH_FINGERPRINT` [tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets)

*note: use this command to get the md5 of the key, use this as ssh_fingerprint*

```sh
ssh-keygen -E md5 -lf ~/.ssh/do_rsa.pub | awk '{print $2}' | sed "s/^MD5://"
```

## Instructions

### Create terraform.tfvars file

```sh
./scripts/create_tfvars.sh -o . -d <digital ocean token> -s <md5 ssh fingerprint>
```

### Generate CA

```sh
mkdir certs
./scripts/generate_certs.sh -o ./certs
```

### Terraform apply

```sh
terraform get
terraform plan
terraform apply
```

### Ansible

```sh
ansible-playbook --inventory-file=$(which terraform-inventory) -u root playbooks/etcd.yml
ansible-playbook --inventory-file=$(which terraform-inventory) -u root playbooks/kube_controller.yml
ansible-playbook --inventory-file=$(which terraform-inventory) -u root playbooks/kube_worker.yml
```

### Local kubectl

```
wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/darwin/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin
```

Make sure you have kubectl installed locally.

```sh
./scripts/setup-kubectl.sh $(terraform output kube_controller_ips) <token> 
```

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