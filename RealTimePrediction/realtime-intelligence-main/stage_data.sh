#
# Create staging environment to generate data needed
#
export PROJECT_ID=${DEVSHELL_PROJECT_ID}
export BUCKET=$PROJECT_ID-ml
#
#Copy raw flights data from US Bureau of Transportation Statistics (https://www.transtats.bts.gov/)
#
gsutil mb -l us-central1 gs://$BUCKET
#
# Download Flight On Time Data from BTS 
#
YEAR=2015
#
#BTS URL 
#
#SOURCE=https://transtats.bts.gov/PREZIP
#
#Using a mirror
#
SOURCE=https://storage.googleapis.com/data-science-on-gcp/edition2/raw
BASEURL="${SOURCE}/On_Time_Reporting_Carrier_On_Time_Performance_1987_present"


for MONTH in `seq 1 2`; do
      echo "Downloading YEAR=$YEAR ...  MONTH=$MONTH ... from $BASEURL"
      MONTH2=$(printf "%02d" $MONTH)
      #
      #Create a temp directory to store downloaded zip files
      #
      TMPDIR=$(mktemp -d)  
      ZIPFILE=${TMPDIR}/${YEAR}_${MONTH2}.zip
      echo $ZIPFILE
      curl -o $ZIPFILE ${BASEURL}_${YEAR}_${MONTH}.zip
      unzip -d $TMPDIR $ZIPFILE
      gsutil cp $TMPDIR/*.csv gs://$BUCKET/flights/raw/${YEAR}${MONTH2}.csv
      rm -rf $TMPDIR
done
#
#Define Schema for BQ flights_raw table
#
SCHEMA=Year:STRING,Quarter:STRING,Month:STRING,DayofMonth:STRING,DayOfWeek:STRING,FlightDate:DATE,Reporting_Airline:STRING,DOT_ID_Reporting_Airline:STRING,IATA_CODE_Reporting_Airline:STRING,Tail_Number:STRING,Flight_Number_Reporting_Airline:STRING,OriginAirportID:STRING,OriginAirportSeqID:STRING,OriginCityMarketID:STRING,Origin:STRING,OriginCityName:STRING,OriginState:STRING,OriginStateFips:STRING,OriginStateName:STRING,OriginWac:STRING,DestAirportID:STRING,DestAirportSeqID:STRING,DestCityMarketID:STRING,Dest:STRING,DestCityName:STRING,DestState:STRING,DestStateFips:STRING,DestStateName:STRING,DestWac:STRING,CRSDepTime:STRING,DepTime:STRING,DepDelay:STRING,DepDelayMinutes:STRING,DepDel15:STRING,DepartureDelayGroups:STRING,DepTimeBlk:STRING,TaxiOut:STRING,WheelsOff:STRING,WheelsOn:STRING,TaxiIn:STRING,CRSArrTime:STRING,ArrTime:STRING,ArrDelay:STRING,ArrDelayMinutes:STRING,ArrDel15:STRING,ArrivalDelayGroups:STRING,ArrTimeBlk:STRING,Cancelled:STRING,CancellationCode:STRING,Diverted:STRING,CRSElapsedTime:STRING,ActualElapsedTime:STRING,AirTime:STRING,Flights:STRING,Distance:STRING,DistanceGroup:STRING,CarrierDelay:STRING,WeatherDelay:STRING,NASDelay:STRING,SecurityDelay:STRING,LateAircraftDelay:STRING,FirstDepTime:STRING,TotalAddGTime:STRING,LongestAddGTime:STRING,DivAirportLandings:STRING,DivReachedDest:STRING,DivActualElapsedTime:STRING,DivArrDelay:STRING,DivDistance:STRING,Div1Airport:STRING,Div1AirportID:STRING,Div1AirportSeqID:STRING,Div1WheelsOn:STRING,Div1TotalGTime:STRING,Div1LongestGTime:STRING,Div1WheelsOff:STRING,Div1TailNum:STRING,Div2Airport:STRING,Div2AirportID:STRING,Div2AirportSeqID:STRING,Div2WheelsOn:STRING,Div2TotalGTime:STRING,Div2LongestGTime:STRING,Div2WheelsOff:STRING,Div2TailNum:STRING,Div3Airport:STRING,Div3AirportID:STRING,Div3AirportSeqID:STRING,Div3WheelsOn:STRING,Div3TotalGTime:STRING,Div3LongestGTime:STRING,Div3WheelsOff:STRING,Div3TailNum:STRING,Div4Airport:STRING,Div4AirportID:STRING,Div4AirportSeqID:STRING,Div4WheelsOn:STRING,Div4TotalGTime:STRING,Div4LongestGTime:STRING,Div4WheelsOff:STRING,Div4TailNum:STRING,Div5Airport:STRING,Div5AirportID:STRING,Div5AirportSeqID:STRING,Div5WheelsOn:STRING,Div5TotalGTime:STRING,Div5LongestGTime:STRING,Div5WheelsOff:STRING,Div5TailNum:STRING
#
#Create BQ Dataset
#
bq --project_id $PROJECT_ID show flights || bq mk --sync flights
#
# Create BQ table flights_raw in flights dataset and load the raw CSV files copied in the previous steps
#
for MONTH in `seq -w 1 2`; do
    CSVFILE=gs://$BUCKET/flights/raw/20150$MONTH.csv
    bq --project_id $PROJECT_ID  --sync load \
     --time_partitioning_field=FlightDate --time_partitioning_type=MONTH \
     --source_format=CSV --ignore_unknown_values --skip_leading_rows=1 --schema=$SCHEMA \
     --replace $PROJECT_ID:flights.flights_raw\$20150$MONTH $CSVFILE
done
#
# Copy all flights time zone corrected JSON file
#
gsutil -m cp gs://data-science-on-gcp/edition2/flights/tzcorr/all_flights-00000-of-00026  gs://${BUCKET}/flights/tzcorr/
#
# Create BQ table flights_tzcorr - time zone corrected
#
bq --project_id $PROJECT_ID load \
   --source_format=NEWLINE_DELIMITED_JSON \
   --autodetect ${PROJECT_ID}:flights.flights_tzcorr gs://${BUCKET}/flights/tzcorr/all_flights-*
#
#Copy Airport Information
#
gsutil cp gs://data-science-on-gcp/edition2/raw/airports.csv gs://${BUCKET}/flights/airports/airports.csv
#
# Create BQ airports table
#
bq --project_id=$PROJECT_ID load  --autodetect --replace --source_format=CSV ${PROJECT_ID}:flights.airports gs://${BUCKET}/flights/airports/airports.csv
#
# Copy Simulated events file
#
gsutil -m cp gs://cloud-training/gsp201/simevents/flights_simevents_dump00000000000*.csv.gz gs://$BUCKET/
#
# Create BQ Simevents Table
#
bq load --replace --autodetect --source_format=CSV flights.flights_simevents gs://$BUCKET/flights_simevents_dump00000000000*.csv.gz
