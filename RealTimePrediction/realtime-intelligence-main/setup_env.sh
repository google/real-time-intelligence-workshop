#Set Project Variables
PROJECT_ID=${DEVSHELL_PROJECT_ID}
PROJECT_NBR=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
NETWORK=default
SUBNET=default
SUBNET_CIDR=10.6.0.0/24
REGION=us-central1
#
#Enable APIs
#
gcloud services enable compute.googleapis.com
gcloud services enable dataflow.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable bigquery.googleapis.com
gcloud services enable monitoring.googleapis.com
#
#Provide roles to the compute service account
#
gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member=serviceAccount:$PROJECT_NBR-compute@developer.gserviceaccount.com \
   --role="roles/storage.objectAdmin"  

gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member=serviceAccount:$PROJECT_NBR-compute@developer.gserviceaccount.com \
   --role="roles/bigquery.jobUser"  

gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member=serviceAccount:$PROJECT_NBR-compute@developer.gserviceaccount.com \
   --role="roles/bigquery.dataEditor" 

gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member=serviceAccount:$PROJECT_NBR-compute@developer.gserviceaccount.com \
   --role="roles/dataflow.worker"    

gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member=serviceAccount:$PROJECT_NBR-compute@developer.gserviceaccount.com \
   --role="roles/dataflow.developer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member=serviceAccount:$PROJECT_NBR-compute@developer.gserviceaccount.com \
   --role="roles/aiplatform.user"

gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member=serviceAccount:$PROJECT_NBR-compute@developer.gserviceaccount.com \
   --role="roles/pubsub.editor"

#
#Create VPC
#
#gcloud compute networks create $NETWORK \
#--project=$PROJECT_ID \
#--subnet-mode=custom \
#--mtu=1460 \
#--bgp-routing-mode=regional
#
#Create Subnet
#
#gcloud compute networks subnets create $SUBNET \
# --network=$NETWORK \
# --range=$SUBNET_CIDR \
# --region=$REGION \
# --enable-private-ip-google-access \
# --project=$PROJECT_ID 
#
#Create Firewall Rules
#
#gcloud compute --project=$PROJECT_ID firewall-rules create allow-intra-$SUBNET \
#--direction=INGRESS \
#--priority=1000 \
#--network=$NETWORK \
#--action=ALLOW \
#--rules=all \
#--source-ranges=$SUBNET_CIDR


# If needed turn off the following policies
# shielded vm policy constraints/compute.requireShieldedVm
# Allow constraints/compute.vmExternalIpAccess

