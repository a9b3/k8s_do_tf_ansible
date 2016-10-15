usage() {
cat << EOF
usage: $0 options

OPTIONS:
  -h help
  -d digital ocean token
  -s ssh fingerprint
  -o output location
EOF
}

do_token=
ssh_fingerprint=
output=
while getopts 'ho:' flag; do
  case "${flag}" in
    h)
      usage
      exit 1
      ;;
    d) do_token="${OPTARG}" ;;
    s) ssh_fingerprint="${OPTARG}" ;;
    o) output="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ -z $do_token ]] || [[ -z $ssh_fingerprint ]] || [[ -z $output ]]
then
  usage
  exit 1
fi

createTfvars() {
echo 'do_token = "${do_token}"
ssh_fingerprint = "${ssh_fingerprint}"
etcd_count = "2"
kube-controller_count = "1"
kube-worker_count = "2"' > $output/terraform.tfvars
}

createTfvars
