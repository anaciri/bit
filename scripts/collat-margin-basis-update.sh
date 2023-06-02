#!/bin/bash
#------------------------
# Description: initiate the bolt protocol to suspend maxloss and hyperscale to reset stop-bolt-protocol.sh
#------------------------
# stop on failure
set -e

# Check if the instance argument is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <instance>"
  exit 1
fi
instance="$1"

if [[ -z $BITSRCDIR ]]; then
  echo "Error: BITSRCDIR env variable not set. MUST source bitenv.sh first."
  exit 1
fi
cd "$BITSRCDIR" || exit 1

# -- Rebasis collat and margin from twreport into draft.config
./rebasis.py ../../../nol/twreport.csv ../../../nol/src/configs/"$instance"config.json "$instance"

# Move the <instance>draft.config file for further processing
mv ${instance}draft.config ../../../nol/src/configs/

# -- ready to overwrite config.json before restarting the instance in PM2
read -rp "overwrite with backup ${instance}config.json with ${instance}draf.config? (Y/n) " choice

case "$choice" in
  ""|Y|y)
    if [ -f "../../../nol/src/configs/${instance}config.json" ]; then
      cp "../../../nol/src/configs/${instance}config.json" "../../../nol/src/configs/${instance}config.json.bkp"
      echo "Existing config file backed up as ${instance}config.json.bkp"
    fi
    cp "../../../nol/src/configs/${instance}draft.config" "../../../nol/src/configs/${instance}config.json"
    echo "config updated"
    ;;
  *)
    echo "Operation canceled."
    ;;
esac
