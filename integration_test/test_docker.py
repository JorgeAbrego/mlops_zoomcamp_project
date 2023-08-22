import pytest
from predict import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_predict_endpoint_with_valid_data(client):
    data = {
        'gender': 'Female',
        'SeniorCitizen': 0,
        'Partner': 'No',
        'Dependents': 'No',
        'tenure': 41,
        'PhoneService': 'Yes',
        'MultipleLines': 'No',
        'InternetService': 'DSL',
        'OnlineSecurity': 'Yes',
        'OnlineBackup': 'No',
        'DeviceProtection': 'Yes',
        'TechSupport': 'Yes',
        'StreamingTV': 'Yes',
        'StreamingMovies': 'Yes',
        'Contract': 'One year',
        'PaperlessBilling': 'Yes',
        'PaymentMethod': 'Credit card (automatic)',
        'MonthlyCharges': 79.85,
        'TotalCharges': 3320.75
    }
    response = client.post("/predict", json=data)
    assert response.status_code == 200
    assert "prediction" in response.get_json()

def test_predict_endpoint_with_invalid_data(client):
    data = {
        'gender': 'Female',
        'SeniorCitizen': 0,
        'Partner': 'No',
        'Dependents': 'No',
        'tenure': 41,
        'PhoneService': 'Yes',
        'MultipleLines': 'No',
        'InternetService': 'DSL',
        'OnlineSecurity': 'Yes',
        'OnlineBackup': 'No',
        'DeviceProtection': 'Yes',
        'TechSupport': 'Yes',
        'StreamingTV': 'Yes',
        'StreamingMovies': 'Yes',
        'Contract': 'One year',
        'PaperlessBilling': 'Yes',
        'PaymentMethod': 'Credit card (automatic)',
        'MonthlyCharges': 79.85,
        'TotalCharges': 3320.75
    }
    response = client.post("/predict", json=data)
    assert response.status_code == 400  # or whatever error code you expect
    assert "error" in response.get_json()