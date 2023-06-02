#!/usr/bin/env python3

import csv
import json
import argparse

def update_config(json_baseline_file, json_changes_file):
    output_file = 'confdraft.json'

    # Read in the baseline JSON file
    with open(json_baseline_file, 'r') as f:
        baseline_data = json.load(f)

    # Read in the changes JSON file
    with open(json_changes_file, 'r') as f:
        changes_data = json.load(f)

    # Apply changes to all MARKET_MAP entries if the key is "ALL"
    if "MARKET_MAP" in changes_data and "ALL" in changes_data["MARKET_MAP"]:
        all_changes = changes_data["MARKET_MAP"]["ALL"]
        market_map = baseline_data.get("MARKET_MAP", {})
        for key in market_map:
            if key != "ALL":
                market_map[key].update(all_changes)

    # Update the baseline data with the changes
    updated_data = recursive_merge(baseline_data, changes_data)

    # Write the updated JSON data to the output file
    with open(output_file, 'w') as f:
        json.dump(updated_data, f, indent=4)

def recursive_merge(dict1, dict2):
    for key in dict2:
        if key in dict1 and isinstance(dict1[key], dict) and isinstance(dict2[key], dict):
            recursive_merge(dict1[key], dict2[key])
        else:
            dict1[key] = dict2[key]
    return dict1

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('json_baseline_file', help='JSON file to be modified.')
    parser.add_argument('json_changes_file', help='JSON config file containing changes.')
    args = parser.parse_args()

    update_config(args.json_baseline_file, args.json_changes_file)
