from flask import Flask, request, jsonify
from tensorflow.keras.preprocessing import image
import numpy as np
import tensorflow as tf
import os

# Initialize Flask app
app = Flask(__name__)

# Check TensorFlow version
print('TensorFlow Version:', tf.__version__)

# Load your trained models
language_model = tf.keras.models.load_model('./language_identifier_mobilenetv2.h5')
era_model = tf.keras.models.load_model('./era_predict_model.h5')

# Class names from training
language_class_names = ['pali', 'sanskrutha', 'sinhala', 'unknown']
era_class_names = ['mahanuwara', 'polonnaruwa']

# Prediction function for language
def predict_language(img_path):
    # Preprocess the image
    img = image.load_img(img_path, target_size=(224, 224))  # Resize image to match model input size
    img_array = image.img_to_array(img)  # Convert image to array
    img_array = tf.expand_dims(img_array, 0)  # Add batch axis (model expects a batch)

    # Make prediction
    pred = language_model.predict(img_array)
    confidence = np.max(pred)  # Get the highest confidence score
    predicted_class = language_class_names[np.argmax(pred)]  # Get the predicted class

    return predicted_class, confidence, pred

# Prediction function for era
def predict_era(img_path):
    # Preprocess the image for the era model
    img = image.load_img(img_path, target_size=(180, 180))  # Resize image to match model input size
    img_array = image.img_to_array(img)  # Convert image to array
    img_array = tf.expand_dims(img_array, 0)  # Add batch axis (model expects a batch)

    # Make prediction
    pred = era_model.predict(img_array)
    confidence = np.max(pred)  # Get the highest confidence score
    predicted_class = era_class_names[np.argmax(pred)]  # Get the predicted class

    return predicted_class, confidence, pred

# Define the endpoint for image upload and prediction
@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    # Save the uploaded image
    img_path = os.path.join('uploads', file.filename)
    file.save(img_path)

    # Predict the language from the image
    language_predicted_class, language_confidence, language_pred = predict_language(img_path)

    # Predict the era from the image
    era_predicted_class, era_confidence, era_pred = predict_era(img_path)

    # Prepare the response, converting float32 to float
    response = {
        'language_predicted_class': language_predicted_class,
        'language_confidence': round(float(language_confidence * 100),2),  # Convert confidence to float
        'language_class_confidences': {language_class_names[i]: float(language_pred[0][i] * 100) for i in range(len(language_class_names))},  # Convert to float
        'era_predicted_class': era_predicted_class,
        'era_confidence':round(float(era_confidence * 100),2),  # Convert confidence to float
        'era_class_confidences': {era_class_names[i]: float(era_pred[0][i] * 100) for i in range(len(era_class_names))}  # Convert to float
    }

    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0',port=5000)
