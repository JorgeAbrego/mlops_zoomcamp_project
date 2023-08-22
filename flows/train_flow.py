from prefect import task, Flow
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler, OneHotEncoder
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.compose import ColumnTransformer
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import ConfusionMatrixDisplay

# Task 1: Read data
@task
def read_data(filename: str) -> pd.DataFrame:
    df = pd.read_csv(filename)
    df['TotalCharges'] = pd.to_numeric(df['TotalCharges'], errors='coerce')
    df['TotalCharges'].fillna(0, inplace=True)
    return df

# Task 2: Preprocess data
@task
def preprocess_data(df: pd.DataFrame) -> pd.DataFrame:
    df.drop('customerID', axis=1, inplace=True)
    return df

# Task 3: Split data
@task
def split_data(df: pd.DataFrame, target: str):
    X = df.drop(target, axis=1)
    y = df[target]
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)
    return X_train, X_test, y_train, y_test

# For simplicity, we'll omit the MLflow setup and logging from the Prefect flow for now.
# If you want to integrate MLflow into Prefect, it would typically be done via Prefect's logging capabilities or custom state handlers.

# Task 4: Train model
@task
def train_model(X_train, y_train):
    num_features = ['tenure', 'MonthlyCharges', 'TotalCharges']
    scaler = MinMaxScaler()
    
    categorical_columns = [
        'gender', 'SeniorCitizen', 'Partner', 'Dependents',
        'PhoneService', 'MultipleLines', 'InternetService', 'OnlineSecurity',
        'OnlineBackup', 'DeviceProtection', 'TechSupport', 'StreamingTV',
        'StreamingMovies', 'Contract', 'PaperlessBilling', 'PaymentMethod'
    ]
    encoder = OneHotEncoder(drop='first')
    
    preprocessor = ColumnTransformer(
        transformers=[
            ('num', scaler, num_features),
            ('cat', encoder, categorical_columns)
        ],
        remainder='passthrough'
    )
    
    params = dict(penalty='l2', solver='lbfgs', max_iter=500, random_state=42)
    pipeline = make_pipeline(preprocessor, LogisticRegression(**params))
    pipeline.fit(X_train, y_train)
    return pipeline

# Create the Prefect Flow
with Flow("Customer Churn Logistic Regression") as flow:
    # Use a sample file path for demonstration; replace with your actual path
    file_path = './data/WA_Fn-UseC_-Telco-Customer-Churn.csv'
    
    # Define the flow of tasks
    df_init = read_data(file_path)
    df_base = preprocess_data(df_init)
    X_train, X_test, y_train, y_test = split_data(df_base, 'Churn')
    model = train_model(X_train, y_train)

# Execute the flow
flow.run()