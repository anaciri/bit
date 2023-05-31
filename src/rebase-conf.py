#!/usr/bin/env python3

import csv
import json
import argparse

def update_config(csv_file, json_file, instance):
    input_file = csv_file
    output_file = f'{instance}draft.config'

    # Read the JSON data from the config file
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Update collateral and basis margin from twreport.csv
    with open(input_file, 'r') as f:
        reader = csv.reader(f)
        next(reader)  # Skip the first row (header)
        for row in reader:
            key, _, collateral, margin, _ = row
            collateral = float(collateral.strip())
            margin = float(margin.strip())
            data['MARKET_MAP'][key]['START_COLLATERAL'] = collateral
            data['MARKET_MAP'][key]['RESET_MARGIN'] = margin

    # Write the updated JSON data to the output file
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=4)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('csv_file', help='CSV file containing data to update the config file.')
    parser.add_argument('json_file', help='JSON config file to update.')
    parser.add_argument('instance', help='Instance value to prepend to the output file name.')
    args = parser.parse_args()

    update_config(args.csv_file, args.json_file, args.instance)
