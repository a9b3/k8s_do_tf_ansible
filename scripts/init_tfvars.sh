if [ -z $DO_TOKEN ]; then
  echo must set env var DO_TOKEN
  exit 1
fi
if [ -z $DO_SSH_FINGERPRINT ]; then
  echo must set env var DO_SSH_FINGERPRINT
  exit 1
fi

echo 'do_token = "'$DO_TOKEN'"
ssh_fingerprint = "'$DO_SSH_FINGERPRINT'"
dns_service_ip = "10.3.0.10"
etcd_count = "1"
etcd_discovery_token = ""
k8s_master_count = "1"
k8s_minion_count = "3"
k8s_service_ip = "10.3.0.1"
k8s_service_ip_range = "10.3.0.0/24"
k8s_version = "v1.3.0"
pod_network = "10.2.0.0/16"
private_key = "/Users/sam/.ssh/do_rsa"' > terraform.tfvars
