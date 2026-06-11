from pathlib import Path

import h5py
import joblib
import numpy as np
from sklearn.linear_model import SGDClassifier
from sklearn.metrics import accuracy_score, classification_report
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler


BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "ml_data"
MODEL_DIR = BASE_DIR / "models"

TRAIN_H5 = DATA_DIR / "food_c101_n10099_r32x32x3.h5"
TEST_H5 = DATA_DIR / "food_test_c101_n1000_r32x32x3.h5"
MODEL_PATH = MODEL_DIR / "food_classifier.joblib"


def load_h5(path):
    with h5py.File(path, "r") as dataset:
        images = dataset["images"][:].astype("float32") / 255.0
        labels = np.argmax(dataset["category"][:], axis=1)
        class_names = [
            name.decode("utf-8") if isinstance(name, bytes) else str(name)
            for name in dataset["category_names"][:]
        ]

    flat_images = images.reshape(images.shape[0], -1)
    return flat_images, labels, class_names


def main():
    if not TRAIN_H5.exists() or not TEST_H5.exists():
        raise FileNotFoundError(
            "Missing H5 data. Extract the files into backend/ml_data first."
        )

    print("Loading training data...")
    x_train, y_train, class_names = load_h5(TRAIN_H5)

    print("Loading test data...")
    x_test, y_test, _ = load_h5(TEST_H5)

    model = make_pipeline(
        StandardScaler(),
        SGDClassifier(
            loss="log_loss",
            alpha=0.0001,
            max_iter=80,
            tol=1e-3,
            random_state=42,
            n_jobs=-1,
        ),
    )

    print(f"Training on {len(x_train)} images across {len(class_names)} classes...")
    model.fit(x_train, y_train)

    print("Evaluating...")
    predictions = model.predict(x_test)
    accuracy = accuracy_score(y_test, predictions)
    print(f"Accuracy: {accuracy:.4f}")
    print(
        classification_report(
            y_test,
            predictions,
            target_names=class_names,
            zero_division=0,
        )
    )

    MODEL_DIR.mkdir(exist_ok=True)
    joblib.dump(
        {
            "model": model,
            "class_names": class_names,
            "image_size": (32, 32),
            "color_mode": "rgb",
            "accuracy": float(accuracy),
        },
        MODEL_PATH,
    )
    print(f"Saved model to {MODEL_PATH}")


if __name__ == "__main__":
    main()
