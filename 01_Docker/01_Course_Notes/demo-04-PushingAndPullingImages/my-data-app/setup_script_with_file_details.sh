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
  echo "Error: File $SOURCE_CSV_FILE not found."
  exit 1
fi

# Get the file size in bytes
FILE_SIZE_BYTES=$(stat -c%s "$SOURCE_CSV_FILE")

# Convert file size to megabytes using awk
FILE_SIZE_MB=$(awk "BEGIN {printf \"%.2f\", $FILE_SIZE_BYTES/1048576}")

# Get the last modification date of the file
LAST_MODIFIED=$(stat -c %y "$SOURCE_CSV_FILE")

# Get the number of lines in the file
LINE_COUNT=$(wc -l < "$SOURCE_CSV_FILE")

# Echo the file details
echo "The provided data file is: '$SOURCE_CSV_FILE'"
echo "Size of the file: $FILE_SIZE_MB MB"
echo "Last modified: $LAST_MODIFIED"
echo "Number of lines: $LINE_COUNT"

# Call the Python script with the source CSV file as argument
python app.py "$SOURCE_CSV_FILE"

