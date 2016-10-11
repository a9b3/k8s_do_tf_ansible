# ./setup-kubtctl.sh <kube controller ip> <token> <ca file>

kube_controller_ip=https://$1:6443
token=$2
ca_file=$3

cluster_name=cluster
context_name=$cluster_name-context

echo $kube_controller_ip $token $ca_file $cluster_name $context_name

kubectl config set-cluster $cluster_name \
  --certificate-authority=$ca_file \
  --embed-certs=true \
  --server=$kube_controller_ip

kubectl config set-credentials admin --token $token

kubectl config set-context $context_name \
  --cluster=$cluster_name \
  --user=admin

kubectl config use-context $context_name
