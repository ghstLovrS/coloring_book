#data_preprocessing.py
import os
import cv2
import numpy as np

def preprocess_image(image_path, target_size=(224, 224)):
    """
    Preprocesses an image by resizing and normalizing pixel values.
    
    Args:
    - image_path: Path to the image file.
    - target_size: Tuple specifying the target size for resizing the image.
    
    Returns:
    - Preprocessed image as a numpy array.
    """
    # Read image
    image = cv2.imread(image_path)
    # Resize image
    image = cv2.resize(image, target_size)
    # Normalize pixel values
    image = image.astype("float32") / 255.0
    return image

def preprocess_dataset(dataset_dir, target_size=(224, 224)):
    """
    Preprocesses all images in a dataset directory.
    
    Args:
    - dataset_dir: Path to the dataset directory containing subdirectories for each class.
    - target_size: Tuple specifying the target size for resizing the images.
    
    Returns:
    - X: List of preprocessed images as numpy arrays.
    - y: List of labels corresponding to the images.
    """
    X = []
    y = []
    
    # Iterate over subdirectories (classes) in the dataset directory
    for class_name in os.listdir(dataset_dir):
        class_dir = os.path.join(dataset_dir, class_name)
        if os.path.isdir(class_dir):
            # Read images in the class directory
            for image_name in os.listdir(class_dir):
                image_path = os.path.join(class_dir, image_name)
                # Preprocess image
                image = preprocess_image(image_path, target_size)
                # Append preprocessed image and label
                X.append(image)
                y.append(class_name)  # Assuming directory names are class labels
    
    return np.array(X), np.array(y)

# Path to the dataset directory
dataset_dir = "project_root/dataset"

# Preprocess correctly drawn images
X_correct, y_correct = preprocess_dataset(os.path.join(dataset_dir, "correctly_drawn"))

# Preprocess incorrectly drawn images
X_incorrect, y_incorrect = preprocess_dataset(os.path.join(dataset_dir, "incorrectly_drawn"))

# Preprocess reference images
X_references, y_references = preprocess_dataset(os.path.join(dataset_dir, "references"))
