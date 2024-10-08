export SSH_IAP_NETWORK_TAG=
export SSH_INTERNAL_NETWORK_TAG=a
export HTTP_NETWORK_TAG=
export ZONE=us-west1-a


gcloud compute firewall-rules delete open-access
gcloud compute firewall-rules create ssh-ingress --allow=tcp:22 --source-ranges 35.235.240.0/20 --target-tags $SSH_IAP_NETWORK_TAG --network acme-vpc
gcloud compute instances add-tags bastion --tags=$SSH_IAP_NETWORK_TAG --zone=$ZONE
gcloud compute firewall-rules create http-ingress --allow=tcp:80 --source-ranges 0.0.0.0/0 --target-tags $HTTP_NETWORK_TAG --network acme-vpc
gcloud compute instances add-tags juice-shop --tags=$HTTP_NETWORK_TAG --zone=$ZONE
gcloud compute firewall-rules create internal-ssh-ingress --allow=tcp:22 --source-ranges 192.168.10.0/24 --target-tags $SSH_INTERNAL_NETWORK_TAG --network acme-vpc
gcloud compute instances add-tags juice-shop --tags=$SSH_INTERNAL_NETWORK_TAG --zone=$ZONE
 


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#gcloud compute ssh juice-shop --internal-ip