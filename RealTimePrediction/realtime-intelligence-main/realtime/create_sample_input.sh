#!/bin/bash
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

bq query --nouse_legacy_sql --format=sparse \
    "SELECT EVENT_DATA FROM dsongcp.flights_simevents WHERE EVENT_TYPE = 'wheelsoff' AND EVENT_TIME BETWEEN '2015-03-10T10:00:00' AND '2015-03-10T14:00:00' " \
    | grep FL_DATE \
    > simevents_sample.json


bq query --nouse_legacy_sql --format=json \
    "SELECT * FROM dsongcp.flights_tzcorr WHERE DEP_TIME BETWEEN '2015-03-10T10:00:00' AND '2015-03-10T14:00:00' " \
    | sed 's/\[//g' | sed 's/\]//g' | sed s'/\},/\}\n/g' \
    > alldata_sample.json
