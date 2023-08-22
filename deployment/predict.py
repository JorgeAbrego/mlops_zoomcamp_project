import pickle
import pandas as pd
import mlflow
from flask import Flask, request, jsonify

RUN_ID = "60980fc781d4480db329374e48dc7a24"

app = Flask('Telco Churn')

logged_model = f's3://vld-test-mlflow/4/{RUN_ID}/artifacts/model'
model = mlflow.pyfunc.load_model(logged_model)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get JSON from request
        data = request.json
        # Convert data into a Pandas Dataframe
        df = pd.DataFrame([data])
        # Make a prediction
        prediction = model.predict(df)
        return jsonify({"prediction": int(prediction[0])})
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(debug=True)