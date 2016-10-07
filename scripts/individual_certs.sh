# Usage ./individual_certs.sh 10.240.0.10,10.240.0.11
# kubernetes-key.pem
# kubernetes.csr
# kubernetes.pem

ips=$(echo $1 | tr "," "\n")

arr=''
for i in $ips
do
  arr="$arr"'"'"$i"'" '
done
arr=($arr)


compiled=''
# worker0, worker1
for i in "${!arr[@]}"
do
  compiled="$compiled"'"'"worker$i"'" '
done

# ip-10-240-0-20, ip-10-240-0-21
for i in "${!arr[@]}"
do
  yo=$(echo ${arr[$i]} | sed s/\"//g | sed s/\\./-/g)
  compiled="$compiled"'"'"ip-$yo"'" '
done

# ips
for i in "${!arr[@]}"
do
  compiled="$compiled${arr[$i]} "
done

function join_by {
  local IFS="$1"
  shift
  echo "$*"
}

commaIps=$(join_by , $compiled)
display=$(echo $commaIps | sed 's/,/,\\n\ \ \ \ /g')

echo '{
  "CN": "kubernetes",
  "hosts": [
    '"$display"'
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Cluster",
      "ST": "Oregon"
    }
  ]
}' > kubernetes-csr.json

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

# EXAMPLE from
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/02-certificate-authority.md
# cat > kubernetes-csr.json <<EOF
# {
#   "CN": "kubernetes",
#   "hosts": [
#     "worker0",
#     "worker1",
#     "worker2",
#     "ip-10-240-0-20",
#     "ip-10-240-0-21",
#     "ip-10-240-0-22",
#     "10.32.0.1",
#     "10.240.0.10",
#     "10.240.0.11",
#     "10.240.0.12",
#     "10.240.0.20",
#     "10.240.0.21",
#     "10.240.0.22",
#     "${KUBERNETES_PUBLIC_ADDRESS}",
#     "127.0.0.1"
#   ],
#   "key": {
#     "algo": "rsa",
#     "size": 2048
#   },
#   "names": [
#     {
#       "C": "US",
#       "L": "Portland",
#       "O": "Kubernetes",
#       "OU": "Cluster",
#       "ST": "Oregon"
#     }
#   ]
# }
# EOF
