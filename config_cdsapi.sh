#!/bin/bash

# Check if the script received the required argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <second_line>"
    exit 1
fi

# Install the cdsapi package
#pip install cdsapi

# Create the .cdsapirc file in the home directory
cdsapirc_path="$HOME/.cdsapirc"

# Write the first line and the provided second line into the .cdsapirc file
echo "url: https://cds.climate.copernicus.eu/api" > "$cdsapirc_path"
echo "$1" >> "$cdsapirc_path"
