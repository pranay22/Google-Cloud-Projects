export ZONE=


gcloud config set compute/zone $ZONE

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud container clusters get-credentials central --zone $ZONE

git clone https://github.com/xiangshen-dk/microservices-demo.git
cd microservices-demo

kubectl apply -f release/kubernetes-manifests.yaml

sleep 30

gcloud logging metrics create Error_Rate_SLI \
  --description="Metrics Error_Rate_SLI" \
  --log-filter="resource.type=\"k8s_container\" severity=ERROR labels.\"k8s-pod/app\": \"recommendationservice\"" 

kubectl get deployments

kubectl apply -f services/hello-blue.yaml

kubectl create -f deployments/hello-green.yaml

curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
kubectl apply -f services/hello-green.yaml