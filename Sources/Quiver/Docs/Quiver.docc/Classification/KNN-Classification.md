# K-Nearest Neighbors Classification

Classify samples by finding the closest training examples.

## Overview

K-Nearest Neighbors (KNN) is one of the most intuitive classification algorithms. Given a new sample, it finds the `k` closest points in the training data and predicts the most common label among them. There is no training phase — the model stores the data and does all the work at prediction time. This makes KNN a "lazy learner," in contrast to models like ``GaussianNaiveBayes`` and ``LinearRegression`` that compute parameters up front.

### How it works

Prediction follows three steps for each new sample:

1. **Measure distance** from the sample to every training point
2. **Select the k nearest** neighbors by sorting distances
3. **Vote** — the most common label among those neighbors wins

The algorithm's simplicity is its strength: no assumptions about how the data is distributed, no parameters to optimize, and the decision boundary adapts automatically to the shape of the data. The tradeoff is that prediction requires scanning the entire training set for every query.

### The distance connection

KNN relies on the same `distance(to:)` operation used throughout Quiver's vector mathematics. This is Euclidean distance — the straight-line distance between two points in n-dimensional space, computed as √Σ(aᵢ − bᵢ)². The same function powers centroid assignment in ``KMeans`` and similarity operations in <doc:Similarity-Operations>. Understanding this single linear algebra concept — that vectors are points in space and distance measures how far apart they are — unlocks classification, clustering, and similarity search simultaneously.

### Fitting a model

The `fit(features:labels:k:metric:weight:)` static method stores the training data and returns a ready-to-use model. Because KNN is a lazy learner, fitting is instantaneous — no computation happens until prediction:

```swift
import Quiver

// Training data: 4 samples with 2 features each
let features: [[Double]] = [
    [1.0, 2.0], [1.5, 1.8],   // class 0
    [5.0, 8.0], [6.0, 9.0]    // class 1
]
let labels = [0, 0, 1, 1]

let model = KNearestNeighbors.fit(features: features, labels: labels, k: 3)
```

### Making predictions

The `predict(_:)` method classifies new samples by finding their nearest neighbors and voting:

```swift
import Quiver

let newSamples: [[Double]] = [[2.0, 2.5], [5.5, 7.0]]
let predictions = model.predict(newSamples)
// [0, 1]
```

### Choosing k

The value of `k` controls the tradeoff between sensitivity and smoothness:

- **Small k (e.g., 1 or 3)**: Sensitive to local patterns. Captures fine-grained boundaries but may overfit to noisy data points.
- **Large k (e.g., 15 or 21)**: Smoother decision boundaries. More robust to noise but may miss local patterns.
- **Odd values** avoid ties in binary classification. With two classes and `k=4`, a 2-2 tie requires a tiebreaker. With `k=3`, one class always wins.

A common starting point is `k = √n` where `n` is the number of training samples, rounded to the nearest odd number.

### Distance metrics

Quiver supports two distance metrics via the ``DistanceMetric`` enum:

**Euclidean distance** (default) measures straight-line distance between points. It works well when features have similar scales — but can be dominated by high-magnitude features when scales differ. Use ``FeatureScaler`` to normalize features before fitting:

```swift
import Quiver

// Scale features to [0, 1] range before fitting
let scaler = FeatureScaler.fit(features: trainX)
let model = KNearestNeighbors.fit(
    features: scaler.transform(trainX),
    labels: trainY,
    k: 5,
    metric: .euclidean
)
let predictions = model.predict(scaler.transform(testX))
```

**Cosine distance** measures the angle between vectors, ignoring their magnitude. It is preferred for text embeddings, TF-IDF vectors, and high-dimensional sparse data where direction matters more than scale:

```swift
import Quiver

let model = KNearestNeighbors.fit(
    features: embeddings,
    labels: categories,
    k: 5,
    metric: .cosine
)
```

### Vote weighting

By default, each neighbor gets one vote (``VoteWeight/uniform``). With ``VoteWeight/distance``, closer neighbors get more influence — their vote is weighted by `1 / distance`. This helps when the query point sits near a decision boundary:

```swift
import Quiver

// Distance-weighted: a single very close neighbor can outweigh
// several distant neighbors from another class
let model = KNearestNeighbors.fit(
    features: features,
    labels: labels,
    k: 5,
    weight: .distance
)
```

### The full pipeline

A typical workflow combines data splitting, optional scaling, model fitting, and evaluation:

```swift
import Quiver

// 10 flowers: petal length, petal width
let features: [[Double]] = [
    [1.4, 0.2], [1.3, 0.2], [1.5, 0.1], [4.5, 1.5],
    [4.7, 1.4], [4.9, 1.5], [5.1, 1.8], [1.6, 0.2],
    [5.9, 2.1], [4.0, 1.3]
]

// 0 = setosa, 1 = versicolor/virginica
let labels = [0, 0, 0, 1, 1, 1, 1, 0, 1, 1]

// Split
let (trainX, testX) = features.trainTestSplit(testRatio: 0.3, seed: 42)
let (trainY, testY) = labels.trainTestSplit(testRatio: 0.3, seed: 42)

// Scale, fit, predict, evaluate
let scaler = FeatureScaler.fit(features: trainX)
let model = KNearestNeighbors.fit(
    features: scaler.transform(trainX),
    labels: trainY,
    k: 3
)
let predictions = model.predict(scaler.transform(testX))
let cm = predictions.confusionMatrix(actual: testY)
print("Accuracy: \(cm.accuracy)")
```

### Organizing data with Panel

The same pipeline using `Panel` eliminates the need to split features and labels separately. One split keeps all columns aligned automatically:

```swift
import Quiver

let data = Panel([
    ("petalLength", [1.4, 1.3, 1.5, 4.5, 4.7, 4.9, 5.1, 1.6, 5.9, 4.0]),
    ("petalWidth",  [0.2, 0.2, 0.1, 1.5, 1.4, 1.5, 1.8, 0.2, 2.1, 1.3]),
    ("species",     [0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0])
])

// One split — features and labels stay aligned without matching seeds
let (train, test) = data.trainTestSplit(testRatio: 0.3, seed: 42)
let featureColumns = ["petalLength", "petalWidth"]

// Scale, fit, predict, evaluate — same API
let scaler = FeatureScaler.fit(features: train.toMatrix(columns: featureColumns))
let model = KNearestNeighbors.fit(
    features: scaler.transform(train.toMatrix(columns: featureColumns)),
    labels: train.labels("species"),
    k: 3
)
let predictions = model.predict(scaler.transform(test.toMatrix(columns: featureColumns)))
let cm = predictions.confusionMatrix(actual: test.labels("species"))
print("Accuracy: \(cm.accuracy)")
```

`Panel` is entirely optional. The classifier accepts arrays directly, and developers who prefer working with raw arrays can continue to do so. See <doc:Panel> for details.

### When to use KNN

KNN works best when:
- The dataset is small to medium (hundreds to low thousands of samples)
- The decision boundary is irregular and hard to model parametrically
- There is no strong prior about data distribution
- Interpretability matters — it is easy to explain "these are the 5 most similar cases"

KNN struggles with large datasets (prediction scans every training point), high-dimensional data (the "curse of dimensionality" makes distances less meaningful), and features on different scales (use ``FeatureScaler`` to mitigate).

### Safe by design

`KNearestNeighbors` follows the same immutable-struct pattern as `GaussianNaiveBayes` and `LinearRegression`. The model is always ready to use after `fit`, training data stays separate from test data, and reproducible splits ensure consistent results.

## Topics

### Model
- ``KNearestNeighbors``

### Training
- ``KNearestNeighbors/fit(features:labels:k:metric:weight:)``

### Prediction
- ``KNearestNeighbors/predict(_:)``

### Configuration
- ``DistanceMetric``
- ``VoteWeight``

### Related
- <doc:Machine-Learning-Primer>
- <doc:Naive-Bayes>
- <doc:Linear-Regression>
