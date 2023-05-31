#!/bin/bash

# First, copy the twreport.csv file from the remote server to the local machine
scp -i ~/Downloads/pbot.pem uat@159.223.156.94:/home/uat/nol/twreport.csv .

# Wait for the previous command to complete before proceeding
wait

# Then, copy the config.json file from the remote server to the local machine
scp -i ~/Downloads/pbot.pem uat@159.223.156.94:/home/uat/nol/src/configs/config.json .

# Wait for the previous command to complete before proceeding
wait


# execute the config_updater.py script with the twreport.csv and config.json files as inputs
./config_updater.py twreport.csv config.json

wait

# copy draft to remote
scp -i ~/Downloads/pbot.pem draft.config uat@159.223.156.94:/home/uat/nol/src/configs/draft.config
