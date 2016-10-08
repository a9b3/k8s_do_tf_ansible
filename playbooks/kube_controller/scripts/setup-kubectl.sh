{% set current=hostvars[inventory_hostname] %}

kubectl config set-cluster default-cluster \
  --server={{current["j"]}}
