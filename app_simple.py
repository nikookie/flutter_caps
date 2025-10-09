from flask import Flask, request, render_template, jsonify
from werkzeug.utils import secure_filename
import os
from datetime import datetime
from ultralytics import YOLO

app = Flask(__name__)

# Configure upload folder
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Load YOLO model
model = YOLO("best.pt")

# Add CORS headers manually (without flask-cors package)
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response

# ---------------------------
# Route: JSON API (For Flutter)
# ---------------------------
@app.route('/predict', methods=['POST', 'OPTIONS'])
def predict():
    # Handle preflight request
    if request.method == 'OPTIONS':
        return '', 200
        
    if 'image' not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    file = request.files['image']
    
    # Save with timestamp to avoid overwriting
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    original_filename = secure_filename(file.filename)
    filename = f"{timestamp}_{original_filename}"
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(filepath)
    
    print(f"✅ Image saved to: {filepath}")  # Log for verification

    results = model.predict(source=filepath, save=False)

    if results and len(results[0].boxes) > 0:
        box = results[0].boxes[0]
        label = model.names[int(box.cls[0])]
        confidence = round(float(box.conf[0]), 2)  # Decimal format (0.0 to 1.0)

        # Example suggested uses per wood type
        suggestions = {
            "mahogany": "Furniture, cabinets, doors",
            "oak": "Flooring, tables, chairs",
            "narra": "Premium furniture, carvings",
        }
        suggested_use = suggestions.get(label.lower(), "General purpose")

        print(f"✅ Prediction: {label} ({confidence*100}% confidence)")  # Log

        return jsonify({
            "predicted_class": label,
            "confidence": confidence,
            "suggested_use": suggested_use
        })
    else:
        print("❌ No wood detected in image")  # Log
        return jsonify({
            "error": "no_wood_detected",
            "predicted_class": None,
            "confidence": 0,
            "suggested_use": "No wood detected"
        })

if __name__ == '__main__':
    print("🚀 Starting Flask server on http://localhost:5000")
    print(f"📁 Images will be saved to: {os.path.abspath(UPLOAD_FOLDER)}")
    app.run(debug=True, host='0.0.0.0', port=5000)
