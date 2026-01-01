from flask import Flask, request, jsonify
import pandas as pd
import joblib

# Initialize the Flask app
app = Flask(__name__)

# Load the model
model = joblib.load("churn_pred_model.pkl")

@app.route('/')
def home():
    return "Welcome to the Bank Customer Churn Prediction API!"

@app.route("/predict", methods=['POST'])
def predict():
    try:
        # Get input data from the request
        data = request.get_json(force=True)
        X = pd.DataFrame.from_dict(data)
        
        # Make prediction
        prediction = model.predict(X)[0]

        # Return the result
        return jsonify({'Customer Exited': prediction})
    
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
