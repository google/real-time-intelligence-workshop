#
# Set environment variables
#
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT_ID-ml
#
# Train custom ML model on the enriched dataset:
#
cd ./realtime
python3 train_on_vertex.py --project $PROJECT_ID  --bucket $BUCKET --region us-central1 --develop --cpuonly
#
#In the Cloud Console, on the Navigation menu, 
#click Vertex AI > Training to monitor the training pipeline.
#When the status is Finished, click on the training pipeline name to monitor the deployment status.
#Note: It will take around 20 minutes to complete the model training and deployment.