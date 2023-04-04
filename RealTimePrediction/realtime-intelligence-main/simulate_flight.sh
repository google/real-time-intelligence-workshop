#
# Set environment variables
#
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT_ID-ml
#
# Change directory to simulate directory
#
cd ./simulate
#
# Simulate Flights:
#
python3 ./simulate.py --startTime '2015-02-01 00:00:00 UTC' --endTime '2015-03-03 00:00:00 UTC' --speedFactor=30 --project $PROJECT_ID
cd ..