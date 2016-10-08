# Creates the following files
# ca-config.json
# ca-csr.json
# ca-key.pem
# ca.csr
# ca.pem
#
# verify using the following command
# openssl x509 -in ca.pem -text -noout

if ! hash cfssl >/dev/null 2>&1; then
  echo cfssl required install first
  exit 1
fi

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
