#!/bin/bash

basedir="/Users/ayb/mio/code/dfi/nol"
instance="$1"

# Check if instance argument is missing
if [[ -z "$instance" ]]; then
  echo "Error: Instance argument is missing."
  echo "Usage: ./script.sh <instance>"
  exit 1
fi

# execute the rebase.py script with the twreport.csv and modified config.json files as inputs
${basedir}/../ops/bit/src/rebase-conf.py ${basedir}/twreport.csv ${basedir}/src/configs/${instance}config.json ${instance}
echo "executing src/local-rebase.py"

# Wait until the file is written
while [ ! -f ${basedir}/../ops/bit/src/${instance}draft.config ]; do
  sleep 1
done

# copy modified draft.config to remote
mv ${basedir}/../ops/bit/src/${instance}draft.config ${basedir}/src/configs/${instance}draft.config
echo "moved file to ~/nol/src/configs"
