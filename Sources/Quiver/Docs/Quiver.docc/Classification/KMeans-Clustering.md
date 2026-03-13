# K-Means Clustering

Partition data into clusters by iteratively refining centroid positions.

## Overview

K-Means is the most widely used clustering algorithm. Given a set of data points, it groups them into `k` clusters where each point belongs to the cluster with the nearest centroid. Unlike classifiers like `KNearestNeighbors` and `GaussianNaiveBayes`, K-Means is unsupervised — it discovers structure in unlabeled data.

### How it works

The algorithm repeats two steps until centroids stabilize:

1. **Assign** — compute the Euclidean distance from each point to every centroid, and assign each point to the nearest one
2. **Update** — recompute each centroid as the mean position of all points assigned to its cluster

This cycle continues until the centroids stop moving (convergence) or the maximum number of iterations is reached.

### The distance connection

At its core, K-Means relies on the same `distance(to:)` operation used throughout Quiver's vector mathematics. This is Euclidean distance — the straight-line distance between two points in n-dimensional space, computed as √Σ(aᵢ − bᵢ)². The same function powers nearest-neighbor search in `KNearestNeighbors` and similarity operations in <doc:Similarity-Operations>. Understanding this single linear algebra concept — that vectors are points in space and distance measures how far apart they are — unlocks clustering, classification, and similarity search simultaneously.

### Fitting a model

The `fit(data:k:maxIterations:seed:)` static method runs the iterative algorithm and returns a trained model with final centroids and cluster assignments:

```swift
import Quiver

let data: [[Double]] = [
    [1.0, 2.0], [1.5, 1.8], [1.2, 2.1],
    [8.0, 8.0], [8.5, 7.5], [9.0, 8.5]
]

let model = KMeans.fit(data: data, k: 2, seed: 42)
print(model.labels)    // [0, 0, 0, 1, 1, 1]
print(model.centroids) // final cluster centers
```

The `seed` parameter ensures reproducible results. Without it, centroid initialization is random and results may vary between runs.

### Inspecting results

After fitting, the model exposes everything needed to understand the clustering:

```swift
import Quiver

// Which cluster each point belongs to
print(model.labels)      // [0, 0, 0, 1, 1, 1]

// The center of each cluster
print(model.centroids)   // [[1.23, 1.97], [8.5, 8.0]]

// How tight the clusters are (lower = better)
print(model.inertia)     // sum of squared distances to centroids

// How many iterations until convergence
print(model.iterations)  // typically 2-10 for well-separated data
```

### Predicting new points

The `predict(_:)` method assigns new data points to the nearest centroid without retraining:

```swift
import Quiver

let newPoints: [[Double]] = [[2.0, 2.5], [7.0, 7.0]]
let assignments = model.predict(newPoints)
// [0, 1] — first point near cluster 0, second near cluster 1
```

### Choosing k

The right number of clusters depends on the data. A common approach is the **elbow method** — fit models with increasing `k` and plot inertia. The "elbow" where inertia stops decreasing sharply suggests a good `k`:

```swift
import Quiver

let data: [[Double]] = [
    [1.0, 2.0], [1.5, 1.8], [1.2, 2.1],
    [5.0, 5.0], [5.5, 4.8], [4.8, 5.2],
    [9.0, 8.0], [8.5, 8.5], [9.2, 7.8]
]

for k in 1...5 {
    let model = KMeans.fit(data: data, k: k, seed: 42)
    print("k=\(k): inertia=\(model.inertia)")
}
// k=1: inertia=~120   (big drop ahead)
// k=2: inertia=~30    (big drop ahead)
// k=3: inertia=~2     ← elbow
// k=4: inertia=~1.5   (diminishing returns)
// k=5: inertia=~0.8
```

### The full pipeline

A typical workflow combines feature scaling, clustering, and analysis:

```swift
import Quiver

// Customer data: spending score, annual income (different scales)
let data: [[Double]] = [
    [15.0, 39000], [16.0, 81000], [17.0, 6000],
    [81.0, 77000], [77.0, 40000], [76.0, 76000],
    [94.0, 3000],  [87.0, 72000], [90.0, 88000]
]

// Scale features so distance treats both equally
let scaler = FeatureScaler.fit(features: data)
let scaled = scaler.transform(data)

// Cluster
let model = KMeans.fit(data: scaled, k: 3, seed: 42)

// Inspect cluster sizes
for cluster in 0..<3 {
    let count = model.labels.filter { $0 == cluster }.count
    print("Cluster \(cluster): \(count) customers")
}
```

### Organizing data with Panel

The same pipeline using `Panel` keeps column names attached to the data throughout:

```swift
import Quiver

let customers = Panel([
    ("spending", [15.0, 16.0, 17.0, 81.0, 77.0, 76.0, 94.0, 87.0, 90.0]),
    ("income",   [39.0, 81.0, 6.0, 77.0, 40.0, 76.0, 3.0, 72.0, 88.0])
])

let features = customers.toMatrix(columns: ["spending", "income"])
let scaler = FeatureScaler.fit(features: features)
let model = KMeans.fit(data: scaler.transform(features), k: 3, seed: 42)
print(model.labels)
```

`Panel` is entirely optional. The clustering algorithm accepts arrays directly, and developers who prefer working with raw arrays can continue to do so. See <doc:Panel> for details.

### When to use K-Means

K-Means works best when:
- Clusters are roughly spherical and similarly sized
- The number of clusters is known or can be estimated
- Data has continuous (not categorical) features
- Features are scaled to similar ranges (use `FeatureScaler`)

K-Means struggles with:
- Non-spherical cluster shapes (elongated, curved, or nested)
- Clusters of very different sizes or densities
- Categorical data (use k-modes instead)
- Determining the "right" k automatically

### Safe by design

`KMeans` follows the same immutable-struct pattern as `GaussianNaiveBayes`, `LinearRegression`, and `KNearestNeighbors`. The model is always ready to use after `fit`, the training data stays separate from the result, and reproducible seeds ensure consistent results across runs.

## Topics

### Model
- ``KMeans``

### Training
- ``KMeans/fit(data:k:maxIterations:seed:)``

### Prediction
- ``KMeans/predict(_:)``

### Related
- <doc:Machine-Learning-Primer>
- <doc:Nearest-Neighbors-Classification>
- <doc:Feature-Scaling>
