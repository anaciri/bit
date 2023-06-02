#!/bin/bash

# initiate the bolt protocol to suspend maxloss and hyperscale to reset stop-bolt-protocol.sh

# Check if the instance argument is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <instance>"
  exit 1
fi
instance="$1"

cd "$BITSRCDIR" || exit 1

# -- Stop pm2 instance
# TODO

# -- rebase collat and margin basis

# -- modify the instance config json

# -- rebasis collat and margin from twreport
./rebasis.py ../../../nol/twreport.csv ../../../nol/src/configs/"$instance"config.json "$instance"

# Move the <instance>draft.config file
read -rp "Copy and rename ${instance}draft.config to ../../../nol/src/configs/${instance}config.json? (Y/n) " choice

case "$choice" in
  ""|Y|y)
    if [ -f "../../../nol/src/configs/${instance}config.json" ]; then
      mv "../../../nol/src/configs/${instance}config.json" "../../../nol/src/configs/${instance}config.json.bkp"
      echo "Existing config file backed up as ${instance}config.json.bkp"
    fi
    cp "${instance}draft.config" "../../../nol/src/configs/${instance}config.json"
    echo "config updated"
    ;;
  *)
    echo "Operation canceled."
    ;;
esac
