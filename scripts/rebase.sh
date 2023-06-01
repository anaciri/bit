#!/bin/bash

instance="$1"

# Check if instance argument is missing
if [[ -z "$instance" ]]; then
  echo "Error: Instance argument is missing."
  echo "Usage: ./script.sh <instance>"
  exit 1
fi

# First, copy the twreport.csv file from the remote server to the local machine
scp -i ~/Downloads/pbot.pem uat@159.223.156.94:/home/uat/nol/twreport.csv .

# Wait for the previous command to complete before proceeding
wait

# Then, copy the config.json file from the remote server to the local machine
scp -i ~/Downloads/pbot.pem uat@159.223.156.94:/home/uat/nol/src/configs/${instance}config.json .

# Wait for the previous command to complete before proceeding
wait

# execute the rebase.py script with the twreport.csv and modified config.json files as inputs
./src/rebase-conf.py twreport.csv ${instance}config.json ${instance}

wait
# copy modified draft.config to remote
scp -i ~/Downloads/pbot.pem ${instance}draft.config uat@159.223.156.94:/home/uat/nol/src/configs/${instance}draft.config
