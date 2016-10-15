# ./setup-kubtctl.sh -k <kube controller ip> -t <token> -c <ca file>

usage() {
cat << EOF
usage: $0 options

OPTIONS:
  -h help
  -k kubernete controller ip
  -t token
  -c ca file location
EOF
}

k_ip=
token=
ca_file=
while getopts 'hk:t:c:' flag; do
  case "${flag}" in
    h)
      usage
      exit 1
      ;;
    k) k_ip="${OPTARG}" ;;
    t) token="${OPTARG}" ;;
    c) ca_file="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ -z $k_ip ]] || [[ -z $token ]] || [[ -z $ca_file ]]
then
  usage
  exit 1
fi

setupKubectl() {
  kube_controller_ip=https://$k_ip:6443

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
}

setupKubectl
