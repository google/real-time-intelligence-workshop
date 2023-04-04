#
# Set environment variables
#
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT_ID-ml
#
# Change directory to realtime directory
#
cd ./realtime
#
# Create data for Training 
# Run Dataflow Pipeline to create Training Dataset
# Note:  It will take around 15-20 minutes to complete the job.
#
python3 create_traindata.py --input bigquery --project $PROJECT_ID --bucket $BUCKET --region us-central1
#
cd ..
#
#In the GCP Cloud Console menu, navigate to Dataflow > Jobs 
#Open Traindata job and review the Job Graph
#