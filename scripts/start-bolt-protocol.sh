#!/bin/bash
set -e

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

# -- Rebasis collat and margin from twreport into draft.config
./rebasis.py ../../../nol/twreport.csv ../../../nol/src/configs/"$instance"config.json "$instance"

# Move the <instance>draft.config file for further processing
mv ${instance}draft.config ../../../nol/src/configs/

# -- Apply boltconf changes to draft (baseline) pday.py baseline changes
./pday_conf.py ../../../nol/src/configs/"$instance"draft.config ../protocolconfs/boltconf.json
echo "applying boltconf changes to ${instance}draft.config "
# mv pdayconf.py output to configs dir
mv ./confdraft.json ../../../nol/src/configs/${instance}protoconf.json

# -- ready to overwrite config.json before restarting the instance in PM2
read -rp "overwrite with backup ${instance}config.json with ${instance}protoconf.json? (Y/n) " choice

case "$choice" in
  ""|Y|y)
    if [ -f "../../../nol/src/configs/${instance}config.json" ]; then
      cp "../../../nol/src/configs/${instance}config.json" "../../../nol/src/configs/${instance}config.json.bkp"
      echo "Existing config file backed up as ${instance}config.json.bkp"
    fi
    cp "../../../nol/src/configs/${instance}protoconf.json" "../../../nol/src/configs/${instance}config.json"
    echo "config updated"
    ;;
  *)
    echo "Operation canceled."
    ;;
esac
