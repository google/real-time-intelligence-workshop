# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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