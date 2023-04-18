import csv
import json
import argparse

def update_config(csv_file, json_file):
    input_file = csv_file
    output_file = 'draft.config'

    # Read the JSON data from the config file
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Read the input data from the CSV file and update the JSON data
    with open(input_file, 'r') as f:
        reader = csv.reader(f)
        next(reader)  # Skip the first row (header)
        for row in reader:
            key, _, new_value, _ = row
            new_value = float(new_value.strip())  # Strip leading/trailing whitespace characters
            data['MARKET_MAP'][key]['START_COLLATERAL'] = new_value

    # Write the updated JSON data to the output file
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=4)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('csv_file', help='CSV file containing data to update the config file.')
    parser.add_argument('json_file', help='JSON config file to update.')
    args = parser.parse_args()

    update_config(args.csv_file, args.json_file)
