import csv
import json
import argparse

def update_config(csv_file, json_file):
    input_file = csv_file
    output_file = 'draft.config'

    # Read the JSON data from the config file
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Update collateral and basis margin from twreport.csv. use endCollat col as new START_COLLAT
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
    args = parser.parse_args()

    update_config(args.csv_file, args.json_file)
