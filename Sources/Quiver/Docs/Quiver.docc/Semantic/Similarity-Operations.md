# Similarity Operations

Compute similarity between vectors using cosine similarity and distance metrics.

## Overview

Similarity operations measure how **related** two vectors are. These operations are fundamental for machine learning applications including recommendation systems, word prediction, clustering, semantic search, and nearest neighbor classification.

> Tip: For selecting top-K results from similarity scores, see <doc:Selection>.

## Dot product

The dot product computes the sum of element-wise products between two vectors. It's the fundamental operation underlying cosine similarity and many machine learning algorithms.

```swift
let v1 = [2.0, 3.0, 4.0]
let v2 = [1.0, 2.0, 3.0]

let dotProduct = v1.dot(v2)
// 20.0 = (2×1) + (3×2) + (4×3)
```

**Mathematical definition:**
```
dot(v, w) = v₁w₁ + v₂w₂ + ... + vₙwₙ
```

### Relationship to other operations

The dot product is the foundation for other similarity metrics:

```swift
let v1 = [3.0, 4.0]
let v2 = [5.0, 12.0]

// Raw dot product
let dot = v1.dot(v2)  // 63.0

// Cosine similarity: normalized dot product
let cosine = v1.cosineOfAngle(with: v2)
// dot / (||v1|| × ||v2||) = 63.0 / (5.0 × 13.0) = 0.969
```

### Magnitude vs distance

Both magnitude and Euclidean distance use the Pythagorean theorem, but measure different things. `Magnitude` provides an answer to "how far am I from home (origin)" while Euclidean distance solves "how far is the coffee shop from the library".

```swift
// Magnitude: distance from origin 
let v = [3.0, 4.0]
let mag = v.magnitude  // 5.0 = sqrt(3² + 4²)

// Euclidean distance: distance between any two vectors
let v1 = [1.0, 2.0]
let v2 = [4.0, 6.0]
let dist = v1.distance(to: v2)  // 5.0 = sqrt((4-1)² + (6-2)²)

// Magnitude is a special case - measurement from origin
let equivalentDist = [0.0, 0.0].distance(to: v)  // 5.0 (same as magnitude)
```

This distinction matters for cosine similarity, which normalizes by dividing by the product of magnitudes (`||v1|| × ||v2||`).

> Tip: For normalized vectors (magnitude = 1), dot product equals cosine similarity. This optimization is used in the pre-normalization technique shown later.

## Cosine similarity

Cosine similarity measures the angle between vectors, ranging from -1 (opposite) to 1 (identical). It focuses on direction rather than magnitude.

```swift
let v1 = [0.8, 0.6, 0.0]
let v2 = [0.4, 0.3, 0.0]

let similarity = v1.cosineOfAngle(with: v2)
// 1.0 - identical direction despite different magnitudes
```

**Mathematical definition:**
```
cosine_similarity(v, w) = (v · w) / (||v|| × ||w||)
```

### When to use cosine similarity

- **Text analysis:** Document length doesn't affect similarity
- **Recommendations:** Compare user/item preference vectors
- **Clustering:** Group by semantic meaning
- **Face recognition:** Compare feature vectors

### Range interpretation

- `1.0`: Identical direction (very similar)
- `0.5-0.8`: Related
- `0.0`: Orthogonal (unrelated)
- `-1.0`: Opposite direction

## Batch operations

Compare one vector against many efficiently:

```swift
let query = [0.8, 0.7, 0.9]

let database = [
    [0.8, 0.6, 0.9],  // Vector 1
    [0.2, 0.3, 0.1],  // Vector 2
    [0.7, 0.7, 0.8]   // Vector 3
]

// Compute all similarities at once
let similarities = database.cosineSimilarities(to: query)
// [0.99, 0.42, 0.98]
```

**Result preservation:** `similarities[i]` is the similarity between `database[i]` and `query`.

## Common use cases

### Recommendation systems

Compare user preference vectors against item vectors to suggest relevant content. Higher similarity scores indicate better matches for personalized recommendations.

```swift
// User's preference vector
let userProfile = [0.8, 0.3, 0.9, 0.2]

// Item vectors
let items = [[0.7, 0.4, 0.8, 0.3], [0.2, 0.9, 0.1, 0.7]]

// Find similar items
let scores = items.cosineSimilarities(to: userProfile)
// [0.95, 0.32] - first item matches user preferences
```

### Duplicate detection

Identify near-duplicate documents or data by computing pairwise similarities and filtering pairs above a threshold. Quiver provides a built-in method to efficiently find redundant content in large datasets.

```swift
let documents = [
    [0.8, 0.7, 0.9],
    [0.8, 0.7, 0.9],  // Duplicate
    [0.1, 0.2, 0.1]
]

// Find duplicates with default threshold (0.95)
let duplicates = documents.findDuplicates()

// Or specify custom threshold
let nearDuplicates = documents.findDuplicates(threshold: 0.90)

// Results are sorted by similarity (highest first)
duplicates.forEach { result in
    print("Documents \(result.index1) and \(result.index2) are \(Int(result.similarity * 100))% similar")
}
```

### Clustering validation

Measure cluster cohesion by calculating average pairwise similarity within a group. Higher values indicate tighter, more homogeneous clusters.

```swift
let cluster = [
    [0.8, 0.7, 0.9],
    [0.7, 0.8, 0.8],
    [0.9, 0.6, 0.9]
]

// Calculate cluster cohesion
let cohesion = cluster.clusterCohesion()  // 0.0 to 1.0

// Compare different clusters
let technicalDocs = [[0.8, 0.3, 0.9], [0.7, 0.4, 0.8]]
let sportsDocs = [[0.2, 0.9, 0.1], [0.3, 0.8, 0.2]]

let techCohesion = technicalDocs.clusterCohesion()
let sportsCohesion = sportsDocs.clusterCohesion()

// Higher cohesion = better clustering quality
print("Technical cluster quality: \(Int(techCohesion * 100))%")
print("Sports cluster quality: \(Int(sportsCohesion * 100))%")
```

## See also

- <doc:Selection> - Select top-K largest values
- <doc:Operations> - Vector operations
- <doc:Matrices-Operations> - Matrix operations

## Topics

### Basic operations
- ``Swift/Array/dot(_:)``

### Similarity metrics
- ``Swift/Array/cosineOfAngle(with:)``
- ``Swift/Array/distance(to:)``

### Batch operations
- ``Swift/Array/cosineSimilarities(to:)->[Double]``

### Similarity analysis
- ``Swift/Array/findDuplicates(threshold:)``
- ``Swift/Array/clusterCohesion()``
