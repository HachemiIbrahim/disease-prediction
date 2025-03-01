import joblib
import numpy as np
from db.models import UserInput  # Import from models.py
from repository.nlp_helper import KNOWN_SYMPTOMS, extract_symptoms

# Load trained model
with open(
    r"C:\Users\ibrah\Documents\FastApi\disease-prediction\the model\final_random_forest_model.pkl",
    "rb",
) as file:
    model = joblib.load(file)

# Load the LabelEncoder used during training
with open(
    r"C:\Users\ibrah\Documents\FastApi\disease-prediction\the model\label_encoder.pkl",
    "rb",
) as file:
    le = joblib.load(file)  # This should be the same encoder used on 'diseases' column


def predict_disease(user_input: UserInput):
    """
    API function to process free-text input, extract symptoms,
    and predict the disease using the trained ML model.
    """
    symptoms = extract_symptoms(user_input.description)

    if not symptoms:
        return {"message": "No relevant symptoms detected. Try describing in detail."}

    # Convert symptoms into a binary input vector
    input_vector = np.zeros(len(KNOWN_SYMPTOMS))
    for symptom in symptoms:
        if symptom in KNOWN_SYMPTOMS:
            index = KNOWN_SYMPTOMS.index(symptom)
            input_vector[index] = 1  # Mark as present

    # Make prediction
    prediction = model.predict([input_vector])

    # Decode the predicted label to disease name
    predicted_disease_name = le.inverse_transform(prediction)[0]

    return {"symptoms": symptoms, "predicted_disease": predicted_disease_name}
