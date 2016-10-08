# Usage ./individual_certs.sh 10.240.0.10,10.240.0.11
# kubernetes-key.pem
# kubernetes.csr
# kubernetes.pem

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes
