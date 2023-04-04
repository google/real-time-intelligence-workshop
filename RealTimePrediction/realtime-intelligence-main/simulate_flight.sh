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
# Change directory to simulate directory
#
cd ./simulate
#
# Simulate Flights:
#
python3 ./simulate.py --startTime '2015-02-01 00:00:00 UTC' --endTime '2015-03-03 00:00:00 UTC' --speedFactor=30 --project $PROJECT_ID
cd ..