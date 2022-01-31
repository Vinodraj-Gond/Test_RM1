# create cluster

eksctl create cluster --name sg-fqsa --region ap-south-1 --version 1.21 --vpc-cidr 10.0.0.0/16 --asg-access --without-nodegroup

---

# create security group
# ensure aws cli version 2
# change VpcId to EKSCTL created VPC

aws cloudformation deploy --stack-name staging1-substrate-security-group --template-file=sg.yaml --region=ap-south-1 \
--capabilities "CAPABILITY_AUTO_EXPAND" "CAPABILITY_NAMED_IAM" "CAPABILITY_IAM" 

---

# calico

kubectl delete daemonset -n kube-system aws-node
kubectl apply -f https://docs.projectcalico.org/manifests/calico-vxlan.yaml

---

# nodegroup
# update attachPolicyARNs, securityGroups, ssh-publicKeyName

eksctl create nodegroup --config-file=nodegroup.yaml

# scale
eksctl scale nodegroup --cluster=sg-fqsa --nodes=1 --name=worker-public-xlarge-general

---

# efs

helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver

---

# autoscaler
# update clustername in deployment manifest

kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
kubectl -n kube-system edit deployment.apps/cluster-autoscaler

---

# external-dns
# create external-dns iam policy

eksctl utils associate-iam-oidc-provider --region=ap-south-1 --cluster=sg-fqsa --approve
eksctl create iamserviceaccount --name external-dns --namespace external-dns --cluster sg-fqsa --attach-policy-arn arn:aws:iam::730617358154:policy/external-dns-sg-fqsa-policy --approve --override-existing-serviceaccounts

# update external-dns-workload.yml annotations, deployment spec 

kubectl apply -f external-dns-workload.yml 

---

# nginx

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/aws/deploy.yaml

---

# cert-manager

helm repo add jetstack https://charts.jetstack.io
k create ns cert-manager
helm install cert-manager jetstack/cert-manager --namespace cert-manager --set installCRDs=true --version v1.0.3 -f values.yaml

kubectl apply -f issuer.yaml 
kubectl apply -f namespace.yaml 
kubectl apply -f certificate.yaml 
 
*error need to enter this command [see more:https://stackoverflow.com/questions/61365202/nginx-ingress-service-ingress-nginx-controller-admission-not-found]
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

k apply -f nginx-dummy-loader.yaml 
 
---

# identity mapping

eksctl create iamidentitymapping --cluster sg-fqsa --arn arn:aws:iam::167102087358:role/eks-codebuild --group system:masters --username codebuild

---

# create amazon-cloudwatch namespace
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml

---

# fluentd
# run sh script
sh fluentd.sh


---