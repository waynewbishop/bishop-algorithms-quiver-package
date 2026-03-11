# Naive Bayes Classification

Train a Gaussian Naive Bayes classifier using Quiver's array-based API.

## Overview

Naive Bayes is one of the simplest and most effective classification algorithms. It applies Bayes' theorem with the "naive" assumption that features are conditionally independent given the class label. Despite this strong assumption, Naive Bayes performs surprisingly well in practice and serves as a reliable baseline for classification tasks.

Quiver provides ``GaussianNaiveBayes``, which assumes that the features within each class follow a normal (Gaussian) distribution. The model learns the mean and variance of each feature per class during training, then uses these statistics to classify new samples.

### How Gaussian classification works

The "Gaussian" in Gaussian Naive Bayes refers to the probability density function (PDF) — the mathematical formula that defines the bell curve of a normal distribution. Given a feature value, a class mean, and a class variance, the PDF answers the question: "How likely is this feature value if the sample belongs to this class?"

During prediction, the model evaluates the Gaussian PDF for every feature against every class. It then combines these likelihoods with the class prior probabilities (how common each class is in the training data) to determine which class best explains the observed features. The class with the highest combined score wins.

### Fitting a model

The ``GaussianNaiveBayes/fit(features:labels:)`` static method learns class statistics from training data and returns a ready-to-use model. There is no separate "unfitted" state — the returned struct is immediately usable:

```swift
import Quiver

// Training data: 4 samples with 2 features each
let features: [[Double]] = [
    [1.0, 2.0], [1.5, 1.8],   // class 0
    [5.0, 8.0], [6.0, 9.0]    // class 1
]
let labels = [0, 0, 1, 1]

let model = GaussianNaiveBayes.fit(features: features, labels: labels)

// Inspect what the model learned
for stats in model.classes {
    print("Class \(stats.label): prior=\(stats.prior), means=\(stats.means)")
}
// Class 0: prior=0.5, means=[1.25, 1.9]
// Class 1: prior=0.5, means=[5.5, 8.5]
```

### Making predictions

The ``GaussianNaiveBayes/predict(_:)`` method classifies new samples by computing the log-probability of each class and selecting the most likely one:

```swift
import Quiver

let newSamples: [[Double]] = [[2.0, 2.5], [5.5, 7.0]]
let predictions = model.predict(newSamples)
// [0, 1]
```

For deeper inspection, ``GaussianNaiveBayes/predictLogProbabilities(_:)`` returns the raw log-probabilities for each class, which is useful for understanding how confident the model is in each prediction.

### The full pipeline

A typical workflow combines data splitting, model fitting, prediction, and evaluation:

```swift
import Quiver

// Feature matrix — each row is a customer [credit_score, balance, loyalty]
let features: [[Double]] = [
    [619, 15000, 0.08], [502, 78000, 0.04], [699, 0, 0.42],
    [850, 11000, 0.12], [645, 125000, 0.35], [720, 98000, 0.18],
    [410, 45000, 0.06], [780, 0, 0.50], [590, 175000, 0.10],
    [680, 62000, 0.28], [550, 200000, 0.03], [810, 5000, 0.45],
    [470, 95000, 0.07], [730, 0, 0.38], [620, 140000, 0.15],
    [760, 32000, 0.22], [520, 180000, 0.05], [690, 0, 0.48],
    [580, 112000, 0.09], [840, 8000, 0.40]
]

// Labels — 1 means the customer churned
let labels = [1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]

// Split into training and test sets (same seed keeps them aligned)
let (trainX, testX) = features.trainTestSplit(testRatio: 0.25, seed: 42)
let (trainY, testY) = labels.trainTestSplit(testRatio: 0.25, seed: 42)

// Scale features to [0, 1] when they are on very different scales
let scaledTrainX = trainX.map { $0.scaled(to: 0.0...1.0) }
let scaledTestX = testX.map { $0.scaled(to: 0.0...1.0) }

// Fit and predict
let model = GaussianNaiveBayes.fit(features: scaledTrainX, labels: trainY)
let predictions = model.predict(scaledTestX)

// Evaluate — precision and recall are Optional, forcing explicit handling
let cm = predictions.confusionMatrix(actual: testY)
print("Accuracy:  \(cm.accuracy)")

if let precision = cm.precision {
    print("Precision: \(precision)")
}
if let recall = cm.recall {
    print("Recall:    \(recall)")
}
```

### Why value types matter

``GaussianNaiveBayes`` is a Swift struct — a value type. This design eliminates several common bugs from class-based ML APIs:

**No accidental mutation.** In class-based ML APIs, fitting a scaler mutates the object in place. A common bug is accidentally re-fitting the scaler on test data, which leaks test statistics into the model. In Quiver, ``GaussianNaiveBayes/fit(features:labels:)`` returns a new, immutable model. There is no mutable state to corrupt.

**No unfitted models.** Some APIs allow constructing an empty model and calling `predict` before fitting — a runtime crash. Quiver's static factory method makes this impossible. The only way to obtain a ``GaussianNaiveBayes`` instance is through ``GaussianNaiveBayes/fit(features:labels:)``, which always returns a fully trained model.

**No global random state.** Quiver's ``Swift/Array/trainTestSplit(testRatio:seed:)`` uses a local seeded random number generator. There is no global random seed that can be accidentally overwritten by another part of the codebase.

### Numerical stability

Naive Bayes computes the product of many small probabilities — one Gaussian probability density function value per feature per class. With many features or extreme values, these products underflow to zero in standard floating-point arithmetic. This is exactly what causes some implementations to predict only the majority class when features are on very different scales.

Quiver works entirely in log-space, converting multiplication to addition. This avoids underflow regardless of feature scale or count, producing reliable predictions without requiring data scaling as a workaround for numerical issues.

## Topics

### Model
- ``GaussianNaiveBayes``
- ``GaussianNaiveBayes/ClassStats``

### Training
- ``GaussianNaiveBayes/fit(features:labels:)``

### Prediction
- ``GaussianNaiveBayes/predict(_:)``
- ``GaussianNaiveBayes/predictLogProbabilities(_:)``

### Related
- <doc:Evaluation-Metrics>
- <doc:Sampling>
