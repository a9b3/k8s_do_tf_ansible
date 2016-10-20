./scripts/setup-kubtctl.sh -k $(terraform output kube-controller_ips) -t chAng3m3 -c ./certs/ca.pem
kubectl run nginx --image=nginx --port=80 --replicas=1
kubectl expose deployment nginx --type NodePort
