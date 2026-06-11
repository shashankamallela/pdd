from pathlib import Path

import joblib
import numpy as np
from PIL import Image


BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "models" / "food_classifier.joblib"


_MODEL_BUNDLE = None


def load_model():
    global _MODEL_BUNDLE

    if _MODEL_BUNDLE is None:
        if not MODEL_PATH.exists():
            raise FileNotFoundError(
                f"Food model not found at {MODEL_PATH}. Run train_food_model.py first."
            )
        _MODEL_BUNDLE = joblib.load(MODEL_PATH)

    return _MODEL_BUNDLE


def prepare_image(image_file):
    bundle = load_model()
    width, height = bundle.get("image_size", (32, 32))

    image = Image.open(image_file).convert("RGB").resize((width, height))
    image_array = np.asarray(image, dtype="float32") / 255.0
    return image_array.reshape(1, -1)


def predict_food_image(image_file):
    bundle = load_model()
    model = bundle["model"]
    class_names = bundle["class_names"]

    features = prepare_image(image_file)
    probabilities = model.predict_proba(features)[0]
    best_index = int(np.argmax(probabilities))

    top_indices = np.argsort(probabilities)[::-1][:5]
    top_predictions = [
        {
            "food": class_names[int(index)],
            "confidence": float(probabilities[int(index)]),
        }
        for index in top_indices
    ]

    return {
        "food": class_names[best_index],
        "confidence": float(probabilities[best_index]),
        "top_predictions": top_predictions,
    }
