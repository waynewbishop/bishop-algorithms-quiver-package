# Machine Learning Primer

Core vocabulary and concepts for understanding classification workflows in Quiver.

## Overview

Machine learning is the practice of training a program to recognize patterns in data so it can make predictions on new, unseen examples. Rather than writing rules by hand — "if credit score > 700 and balance < 50000, approve the loan" — we give the algorithm labeled examples and let it discover the decision boundary itself. This primer defines the vocabulary that appears throughout Quiver's classification documentation.

## Features and labels

Every supervised learning problem starts with a dataset where each row is one example and each column is one measurement. The columns the model uses to make predictions are called **features**. The column the model is trying to predict is called the **label** (also known as the target).

Consider a dataset for predicting loan approval:

```swift
import Quiver

let data = Panel([
    ("creditScore", [720.0, 650.0, 580.0, 710.0]),
    ("balance",     [15000.0, 78000.0, 42000.0, 8000.0]),
    ("approved",    [1.0, 0.0, 0.0, 1.0])
])
```

Here, `creditScore` and `balance` are features — the information the model receives as input. `approved` is the label — the outcome we want the model to learn to predict. The model never sees the label at prediction time; it must infer the answer from the features alone.

> Tip: A good mental model is features = question, label = answer. We train the model on many question-answer pairs, then ask it new questions and check whether it gives the right answers.

## Training and test data

If we evaluate a model on the same data it learned from, we get a misleadingly optimistic score — like grading a student on questions they already saw. To get an honest measure of how well the model generalizes, we split the data into two partitions:

- **Training set** — the examples the model learns from (typically 80% of the data)
- **Test set** — the examples held back for evaluation (typically 20%)

```swift
import Quiver

let features = [[720.0, 15000.0], [650.0, 78000.0], [580.0, 42000.0],
                [710.0, 8000.0], [690.0, 55000.0], [620.0, 91000.0],
                [750.0, 12000.0], [600.0, 63000.0], [680.0, 37000.0],
                [640.0, 84000.0]]

let (train, test) = features.trainTestSplit(testRatio: 0.2, seed: 42)
// train: 8 rows for learning
// test:  2 rows for evaluation
```

The `seed` parameter ensures the same split every time, making experiments reproducible. When using a `Panel`, the split is atomic — all columns are partitioned by the same rows, so features and labels stay aligned automatically.

## Data leakage

**Data leakage** occurs when information from the test set influences the training process. The most common form is fitting a preprocessor (like a scaler) on the entire dataset before splitting. If the scaler learns the minimum and maximum from all rows — including the test rows — then the training process has indirectly "seen" the test data, and evaluation results will be overly optimistic.

The fix is simple: fit on training data only, then transform both sets using the same learned statistics:

```swift
import Quiver

// Correct: fit on training data, transform both
let scaler = FeatureScaler.fit(trainFeatures)
let scaledTrain = scaler.transform(trainFeatures)
let scaledTest = scaler.transform(testFeatures)
```

This pattern — fit once on training data, apply everywhere — prevents leakage and gives us an honest evaluation.

## Feature engineering and scaling

Raw data rarely arrives in a form that works well for models. **Feature engineering** is the process of transforming raw inputs into features that better represent the underlying patterns. This might involve combining columns (ratio of balance to income), extracting components (day of week from a timestamp), or encoding categories as numbers.

**Feature scaling** addresses a specific problem: when features have very different magnitudes, larger values can dominate the model's calculations. A credit score ranging from 300–850 and an account balance ranging from 0–250,000 are nearly six orders of magnitude apart. Scaling brings all features to a comparable range so each one contributes proportionally:

```swift
import Quiver

// Min-max scaling: transforms each column to 0–1 range
let scaler = FeatureScaler.fit(trainFeatures)
let scaled = scaler.transform(trainFeatures)
```

Quiver's `FeatureScaler` uses min-max normalization by default, scaling each column independently based on its observed range in the training data. For details on custom ranges and constant-column handling, see <doc:Feature-Scaling>.

## Overfitting and underfitting

A model can fail in two opposite ways:

**Overfitting** means the model has memorized the training data, including its noise and quirks, rather than learning the underlying pattern. It performs well on training data but poorly on new examples. Signs of overfitting include near-perfect training accuracy paired with significantly lower test accuracy.

**Underfitting** means the model is too simple to capture the pattern in the data. It performs poorly on both training and test data. This can happen when the model lacks the capacity to represent the relationship, or when important features are missing.

The goal is a model that generalizes — one that learns the true pattern well enough to make accurate predictions on data it has never seen. Splitting data into training and test sets (and checking both scores) is the primary tool for detecting these problems.

## Classification and regression

Supervised learning problems fall into two categories based on what the label represents:

**Classification** predicts a discrete category — spam or not spam, approved or denied, which digit (0–9) an image contains. The label is a class identifier, and the model's output is a predicted class (sometimes with a confidence score). Quiver's `GaussianNaiveBayes` is a classification model.

**Regression** predicts a continuous value — tomorrow's temperature, a house's sale price, how long a user session will last. The label is a number, and the model's output is a number.

The distinction matters because evaluation metrics differ. Classification uses accuracy, precision, and recall. Regression uses measures like mean squared error and R². Quiver currently focuses on classification workflows.

## Evaluating models

Accuracy — the fraction of correct predictions — is the most intuitive metric, but it can be misleading. If 95% of loan applications are approved, a model that always predicts "approved" achieves 95% accuracy while providing zero useful information.

Better metrics examine the types of errors a model makes:

- **Precision** — of all the examples the model labeled positive, how many actually were? High precision means few false alarms.
- **Recall** — of all the actually positive examples, how many did the model catch? High recall means few missed cases.
- **F1 score** — the harmonic mean of precision and recall, balancing both concerns.

Which metric matters most depends on the cost of each error type. Missing a fraudulent transaction (low recall) is worse than flagging a legitimate one (low precision). For a full treatment of these metrics and the `ConfusionMatrix` type, see <doc:Evaluation-Metrics>.

## See also

- <doc:Sampling> - Train/test splitting and stratified partitioning
- <doc:Feature-Scaling> - Min-max normalization with data leakage prevention
- <doc:Naive-Bayes> - Gaussian Naive Bayes classifier
- <doc:Evaluation-Metrics> - Precision, recall, F1, and confusion matrices
- <doc:Panel-Overview> - Organizing labeled columnar data
