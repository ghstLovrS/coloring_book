import numpy as np
from data_preprocessing import X_correct, y_correct, X_incorrect, y_incorrect, X_references, y_references
from model import create_model

# Concatenate correctly and incorrectly drawn images
X_train = np.concatenate((X_correct, X_incorrect))
y_train = np.concatenate((y_correct, y_incorrect))

# Create and compile the model
model = create_model(input_shape=X_train[0].shape)

# Train the model
history = model.fit(X_train, y_train, epochs=10, validation_data=(X_references, y_references))

# Evaluate the model on the validation set
loss, accuracy = model.evaluate(X_references, y_references)
print("Validation Accuracy:", accuracy)

# Save the trained model
model.save("coloring_book/trained_model.h5")
