# Disease Prediction App

This project is an AI-powered disease prediction system that allows users to describe their symptoms in natural language and get a predicted disease based on an ML model.

## Project Structure
- **app/**: The frontend built using Flutter.
- **backend/**: The FastAPI backend for processing requests.
- **model/**: The trained machine learning model for disease prediction.
- **notebooks/**: Jupyter notebooks for training and testing the model.

## Setup Instructions

### 1. Clone the Repository
```sh
git clone https://github.com/yourusername/disease-prediction.git
cd disease-prediction
```

### 2. Download the Dataset
Download the dataset from Kaggle: [Diseases and Symptoms Dataset](https://www.kaggle.com/datasets/dhivyeshrk/diseases-and-symptoms-dataset)

Extract the dataset into the `model/` or `notebooks/` directory.

### 3. Run the Notebook
Navigate to the `notebooks/` directory and open the Jupyter notebook to train or test the model.
```sh
jupyter notebook
```

### 4. Install Dependencies
#### Backend (FastAPI)
```sh
cd backend
pip install -r requirements.txt
```

#### Frontend (Flutter)
```sh
cd app
flutter pub get
```

### 5. Run the Backend Server
```sh
cd backend
uvicorn main:app --reload
```

### 6. Run the Flutter App
```sh
cd app
flutter run
```

## API Endpoints
- `POST /prediction/predict`: Accepts symptoms as input and returns the predicted disease.


<img src="images/Screenshot 2025-03-09 135537.png" alt="Image Description" width="300" height="500">
<img src="images/Screenshot 2025-03-09 135803.png" alt="Image Description" width="300" height="500">

