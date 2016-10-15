# ./generate_certs.sh -o <certs folder>

usage() {
cat << EOF
usage: $0 options

OPTIONS:
  -h help
  -o output location
EOF
}

output=''
while getopts 'ho:' flag; do
  case "${flag}" in
    h)
      usage
      exit 1
      ;;
    o) output="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ -z $output ]]
then
  usage
  exit 1
fi

if ! hash cfssl >/dev/null 2>&1; then
  echo cfssl required install first
  exit 1
fi

# Creates the following files
# ca-config.json
# ca-csr.json
# ca-key.pem
# ca.csr
# ca.pem
#
# verify using the following command
# openssl x509 -in ca.pem -text -noout
generateCerts() {
cd $output

echo '{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}' > ca-config.json

echo '{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}' > ca-csr.json

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

openssl req \
  -out admin.csr \
  -new -newkey rsa:2048 \
  -nodes \
  -keyout admin.key \
  -subj '/CN=kubernetes'

openssl x509 \
  -req \
  -in admin.csr \
  -CA ca.pem \
  -CAkey ca-key.pem \
  -CAcreateserial \
  -days 365 \
  -out admin.crt
}

generateCerts
