# Naive Bayes Classification

Train a Gaussian Naive Bayes classifier.

## Overview

Naive Bayes is one of the simplest and most effective classification algorithms. It applies Bayes' theorem with the "naive" assumption that features are conditionally independent given the class label. Despite this strong assumption, Naive Bayes performs surprisingly well in practice and serves as a reliable baseline for classification tasks.

Quiver provides `GaussianNaiveBayes`, which assumes that the features within each class follow a normal (Gaussian) distribution. The model learns the mean and variance of each feature per class during training, then uses these statistics to classify new samples.

### How Gaussian classification works

The "Gaussian" in Gaussian Naive Bayes refers to the probability density function (PDF) — the mathematical formula that defines the bell curve of a normal distribution. Given a feature value, a class mean, and a class variance, the PDF answers the question: "How likely is this feature value if the sample belongs to this class?"

During prediction, the model evaluates the Gaussian PDF for every feature against every class. It then combines these likelihoods with the class prior probabilities (how common each class is in the training data) to determine which class best explains the observed features. The class with the highest combined score wins.

### Fitting a model

The `fit(features:labels:)` static method learns class statistics from training data and returns a ready-to-use model. There is no separate "unfitted" state — the returned struct is immediately usable:

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

The `predict(_:)` method classifies new samples by computing the log-probability of each class and selecting the most likely one:

```swift
import Quiver

let newSamples: [[Double]] = [[2.0, 2.5], [5.5, 7.0]]
let predictions = model.predict(newSamples)
// [0, 1]
```

For deeper inspection, `predictLogProbabilities(_:)` returns the raw log-probabilities for each class, which is useful for understanding how confident the model is in each prediction.

### The full pipeline

A typical workflow combines data splitting, model fitting, prediction, and evaluation.

> Tip: Quiver's `trainTestSplit(testRatio:seed:)` splits any array into training and test subsets with a single call. For imbalanced datasets where one class is much rarer than another, use `stratifiedSplit(labels:testRatio:seed:)` instead — it preserves the class ratios in both partitions. See <doc:Sampling> for details.

```swift
import Quiver

// Feature matrix — each row is a customer [credit_score, balance, loyalty]
let features: [[Double]] = [
    [619, 15000, 0.08], [502, 78000, 0.04], [699, 0, 0.42],
    [850, 11000, 0.12], [645, 125000, 0.35], [720, 98000, 0.18],
    [410, 45000, 0.06], [780, 0, 0.50], [590, 175000, 0.10],
    [680, 62000, 0.28]
]

// Labels — 1 means the customer churned
let labels = [1, 1, 0, 0, 1, 0, 1, 0, 1, 0]

// Split, scale, fit, predict
let (trainX, testX) = features.trainTestSplit(testRatio: 0.25, seed: 42)
let (trainY, testY) = labels.trainTestSplit(testRatio: 0.25, seed: 42)

let scaler = FeatureScaler.fit(features: trainX)
let model = GaussianNaiveBayes.fit(features: scaler.transform(trainX), labels: trainY)
let predictions = model.predict(scaler.transform(testX))

// Evaluate — precision and recall return nil when undefined
let cm = predictions.confusionMatrix(actual: testY)
print("Accuracy: \(cm.accuracy)")
print("Precision: \(cm.precision as Any)")
print("Recall: \(cm.recall as Any)")
```

### Safe by design

`GaussianNaiveBayes` is a Swift struct, which means it cannot be accidentally changed after creation. This design prevents three common mistakes:

**The model is always ready to use.** Calling `fit(features:labels:)` returns a fully trained model in one step. There is no way to create an empty model and forget to train it before making predictions.

**Training data stays separate from test data.** Both `GaussianNaiveBayes` and `FeatureScaler` are immutable once created. Fitting the scaler on training data and applying it to both sets ensures that test data never influences the scaling — a subtle but common source of data leakage in ML pipelines.

**Reproducible splits.** Each call to `trainTestSplit(testRatio:seed:)` uses its own seed. There is no shared random state that other code can interfere with, so the same seed always produces the same split.

### Numerical stability

Naive Bayes multiplies together one probability for every feature in every class. With many features, these probabilities become extremely small numbers that can round to zero, causing the model to stop distinguishing between classes. Quiver handles this internally by working with logarithms, which keeps the arithmetic accurate regardless of how many features the data contains.

## Topics

### Model
- ``GaussianNaiveBayes``
- ``GaussianNaiveBayes/ClassStats``

### Training
- ``GaussianNaiveBayes/fit(features:labels:)``

### Prediction
- ``GaussianNaiveBayes/predict(_:)``
- ``GaussianNaiveBayes/predictLogProbabilities(_:)``

### Data Splitting
- ``Swift/Array/trainTestSplit(testRatio:seed:)``
- ``Swift/Array/stratifiedSplit(labels:testRatio:seed:)``

### Related
- <doc:Feature-Scaling>
- <doc:Evaluation-Metrics>
- <doc:Sampling>
