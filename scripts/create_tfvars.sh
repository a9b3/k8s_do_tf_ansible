#!/bin/bash

# Creates the terraform.tfvars file that terraform uses for orchestration
#
# required arguments
#
# run this command to get md5 fingerprint from do key
# ssh-keygen -E md5 -lf ~/.ssh/do_rsa.pub | awk '{print $2}' | sed "s/^MD5://"
#
# create_tfvars.sh -o <path> -d <do token> -s <md5 ssh fingerprint>

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

do_token=$DO_TOKEN
ssh_fingerprint=$DO_SSH_FINGERPRINT
output=$(pwd)
while getopts ":h:d:s:o:" flag; do
  case $flag in
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

# write into terraform.tfvars
createTfvars() {
echo "do_token = \"$do_token\"
ssh_fingerprint = \"$ssh_fingerprint\"
etcd_count = \"2\"
kube-controller_count = \"1\"
loadbalancer_count = \"1\"
kube-worker_count = \"2\"" > $output/terraform.tfvars
}

createTfvars
