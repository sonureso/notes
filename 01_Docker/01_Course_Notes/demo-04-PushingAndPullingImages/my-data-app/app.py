from flask import Flask, Response

import pandas as pd
import sys

from tabulate import tabulate

app = Flask(__name__)

# Path to the source CSV file (from the command line argument)
csv_file_path = sys.argv[1]

# Route to serve loaded data
@app.route('/')
def home():
    try:
        # Load the DataFrame
        df = pd.read_csv(csv_file_path)

        # Convert DataFrame to CSV string without index
        data_csv = df.head(30)

        # Get the statistical summary
        summary = df.describe()

        # Format the data and summary using tabulate
        data_table = tabulate(data_csv, headers='keys', tablefmt='grid')
        summary_table = tabulate(summary, headers='keys', tablefmt='grid')

        # Return both the formatted data and summary as plain text
        response = f"Loaded Data:\n{data_table}\n\nStatistical Summary:\n{summary_table}"
        
        return Response(response, mimetype='text/plain')

    except Exception as e:
        # If an error occurs, return an error message
        return Response(f"Error: {str(e)}", mimetype='text/plain')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


