#!/bin/bash

# Check if the argument is provided
if [ -z "$1" ]; then
  echo "Data source is not provided"
  echo "Usage: $0 <path_to_source_csv_file>"
  exit 1
fi

SOURCE_CSV_FILE="$1"

# Check if the file exists
if [ ! -f "$SOURCE_CSV_FILE" ]; then
  echo "Error: File $"SOURCE_CSV_FILE" not found."
  exit 1
fi

# Echo the file name 
echo "The name of the data file is $1."

# Call the Python script with the source CSV file as argument
python app.py "$SOURCE_CSV_FILE"

