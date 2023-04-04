#
# Set environment variables
#
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT_ID-ml
#
# Change directory to simulate directory
#
cd ./realtime
#
# Predict Flights:
#
python3 make_predictions.py --input pubsub --output bigquery --project $PROJECT_ID --bucket $BUCKET --region us-central1
cd ..