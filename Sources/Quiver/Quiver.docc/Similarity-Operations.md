# Similarity Operations

Measure semantic similarity between vectors using cosine similarity, distance metrics, and batch operations.

## Overview

Once text is converted to numerical vectors (see <doc:Text-Processing>), we need mathematical operations to measure how similar two vectors are. Similarity metrics enable semantic search, recommendation systems, and clustering by quantifying the relationship between vector representations.

Quiver provides efficient similarity operations optimized for high-dimensional vectors commonly used in machine learning and natural language processing.

## Cosine Similarity

Cosine similarity measures the angle between two vectors, ranging from -1 (opposite directions) to 1 (identical directions). It focuses on **direction** rather than magnitude, making it ideal for comparing text embeddings where document length shouldn't affect similarity.

```swift
let doc1 = [0.8, 0.6, 0.0]  // "running shoes"
let doc2 = [0.4, 0.3, 0.0]  // "jogging sneakers" (similar direction, smaller magnitude)

let similarity = doc1.cosineOfAngle(with: doc2)
// 1.0 - identical semantic meaning despite different magnitudes
```

### Why Cosine for Text?

Consider two product descriptions:
- Short: "running shoes"
- Long: "comfortable lightweight breathable running shoes for marathon training"

Both are about running shoes, but the long description has more words, resulting in a larger vector magnitude. Cosine similarity ignores magnitude and measures only directional alignment—exactly what we need for semantic comparison.

### Mathematical Definition

For vectors v and w:

```
cosine_similarity(v, w) = (v · w) / (||v|| × ||w||)
```

Where:
- `v · w` is the dot product
- `||v||` is the magnitude of v
- `||w||` is the magnitude of w

### Practical Examples

**High similarity (related meanings):**
```swift
let athletic = [0.8, 0.7, 0.9, 0.2]  // Athletic activity
let fitness = [0.7, 0.8, 0.8, 0.3]   // Similar context

athletic.cosineOfAngle(with: fitness)  // ~0.95 (very similar)
```

**Low similarity (unrelated meanings):**
```swift
let running = [0.8, 0.7, 0.9, 0.2]   // Athletic activity
let computer = [0.1, 0.2, 0.1, 0.9]  // Technology

running.cosineOfAngle(with: computer)  // ~0.15 (very different)
```

**Perpendicular (orthogonal) vectors:**
```swift
let v1 = [1.0, 0.0]
let v2 = [0.0, 1.0]

v1.cosineOfAngle(with: v2)  // 0.0 (completely unrelated)
```

## Euclidean Distance

Euclidean distance measures the straight-line distance between two points in vector space. Unlike cosine similarity, distance considers both direction and magnitude.

```swift
let point1 = [3.0, 4.0]
let point2 = [0.0, 0.0]

let dist = point1.distance(to: point2)
// 5.0 (Pythagorean theorem: sqrt(3² + 4²))
```

### When to Use Distance vs Similarity

**Use Euclidean distance when:**
- Magnitude matters (physical positions, measurements)
- Working with normalized vectors
- Clustering spatial data

**Use cosine similarity when:**
- Direction matters more than magnitude (text semantics)
- Comparing variable-length documents
- Working with word embeddings

### Example: Different Metrics, Different Results

```swift
let short = [1.0, 1.0]
let long = [10.0, 10.0]

// Cosine: same direction
short.cosineOfAngle(with: long)  // 1.0 (identical direction)

// Distance: different magnitudes
short.distance(to: long)  // ~12.7 (far apart in space)
```

## Batch Similarity Operations

For semantic search, we often compare one query vector against many document vectors. Batch operations process all comparisons efficiently.

```swift
let query = [0.8, 0.7, 0.9]

let database = [
    [0.8, 0.6, 0.9],  // Doc 1
    [0.2, 0.3, 0.1],  // Doc 2
    [0.7, 0.7, 0.8],  // Doc 3
    [0.1, 0.1, 0.2]   // Doc 4
]

// Compute all similarities at once
let similarities = database.cosineSimilarities(to: query)
// [0.99, 0.42, 0.98, 0.28]
```

The `.cosineSimilarities(to:)` method:
- Computes cosine similarity between each vector in the array and the target
- Returns array of similarity scores
- Preserves order (result[i] is similarity of database[i] to query)
- Efficient for large-scale searches

### Semantic Search Example

```swift
import Quiver

// Load and embed documents
let embeddings = try loadGloVe(from: "glove.6B.50d.txt")

let products = [
    "lightweight running shoes for marathons",
    "durable trail running sneakers",
    "comfortable jogging footwear",
    "laptop computer for programming"
]

let database = products.compactMap {
    $0.tokenize().embed(using: embeddings).averaged()
}

// Search query
let query = "best running shoes for training"
let queryVector = query.tokenize()
    .embed(using: embeddings)
    .averaged()!

// Find similarities
let similarities = database.cosineSimilarities(to: queryVector)
// [0.87, 0.82, 0.79, 0.12]
// First 3 products are similar (running/shoes/jogging)
// Last product very different (laptop/computer)
```

## Similarity Properties

### Range and Interpretation

**Cosine similarity:**
- Range: -1 to 1
- 1.0: Identical direction (perfect match)
- 0.0: Orthogonal (unrelated)
- -1.0: Opposite direction (antonyms)
- Typical text: 0.0 to 1.0 (negative rare in word embeddings)

**Practical thresholds:**
- >0.8: Very similar (near-duplicates, synonyms)
- 0.5-0.8: Related (same topic, different aspects)
- 0.3-0.5: Weakly related (overlapping concepts)
- <0.3: Unrelated (different topics)

### Symmetry

Both cosine similarity and Euclidean distance are symmetric:

```swift
v1.cosineOfAngle(with: v2) == v2.cosineOfAngle(with: v1)  // Always true
v1.distance(to: v2) == v2.distance(to: v1)                // Always true
```

This means order doesn't matter when comparing vectors.

## Performance Optimization

### Pre-normalization

For repeated comparisons, normalize vectors once:

```swift
// Normalize documents once
let normalizedDocs = database.map { $0.normalized }
let normalizedQuery = query.normalized

// Fast comparisons (dot product = cosine for normalized vectors)
let similarities = normalizedDocs.map { $0.dot(normalizedQuery) }
```

When vectors are normalized (magnitude = 1), dot product equals cosine similarity, eliminating division operations.

### Batch Processing

Process many queries efficiently:

```swift
// Multiple queries
let queries = [
    "running shoes",
    "laptop computer",
    "tennis racket"
].compactMap { $0.tokenize().embed(using: embeddings).averaged() }

// Compare all queries to all documents
let allSimilarities = queries.map { query in
    database.cosineSimilarities(to: query)
}

// allSimilarities[i][j] = similarity of query i to document j
```

## Practical Applications

### Duplicate Detection

```swift
// Find near-duplicate documents
let threshold = 0.95

for i in 0..<documents.count {
    for j in (i+1)..<documents.count {
        let sim = documents[i].cosineOfAngle(with: documents[j])
        if sim > threshold {
            print("Documents \(i) and \(j) are duplicates (similarity: \(sim))")
        }
    }
}
```

### Content Recommendation

```swift
// Recommend similar articles to what user is reading
let currentArticle = userReadingVector

let recommendations = articleDatabase
    .cosineSimilarities(to: currentArticle)
    .enumerated()
    .sorted { $0.element > $1.element }  // Descending by similarity
    .prefix(5)  // Top 5
    .map { (index: $0.offset, similarity: $0.element) }
```

### Clustering Validation

```swift
// Check if items in a cluster are actually similar
func clusterQuality(items: [[Double]]) -> Double {
    guard items.count > 1 else { return 0 }

    var totalSimilarity = 0.0
    var count = 0

    for i in 0..<items.count {
        for j in (i+1)..<items.count {
            totalSimilarity += items[i].cosineOfAngle(with: items[j])
            count += 1
        }
    }

    return totalSimilarity / Double(count)
}

let quality = clusterQuality(items: clusterItems)
// High quality > 0.7 (items are similar)
// Low quality < 0.5 (items are dissimilar - poor clustering)
```

## For Python Developers

Quiver's similarity operations match scikit-learn and SciPy:

**Python (scikit-learn):**
```python
from sklearn.metrics.pairwise import cosine_similarity

similarity = cosine_similarity([v1], [v2])[0][0]
similarities = cosine_similarity([query], database)[0]
```

**Swift (Quiver):**
```swift
let similarity = v1.cosineOfAngle(with: v2)
let similarities = database.cosineSimilarities(to: query)
```

**Python (SciPy):**
```python
from scipy.spatial.distance import euclidean, cosine

dist = euclidean(v1, v2)
cos_sim = 1 - cosine(v1, v2)  # SciPy returns distance, not similarity
```

**Swift (Quiver):**
```swift
let dist = v1.distance(to: v2)
let cosSim = v1.cosineOfAngle(with: v2)
```

## For iOS Developers

### Integration with CoreML

```swift
import CoreML
import Quiver

// Compare CoreML predictions
let prediction1 = model.prediction(from: image1).featureVector
let prediction2 = model.prediction(from: image2).featureVector

let similarity = prediction1.cosineOfAngle(with: prediction2)

if similarity > 0.8 {
    print("Images contain similar content")
}
```

### Vision Framework Integration

```swift
import Vision
import Quiver

// Compare image embeddings from Vision framework
func compareImages(_ image1: UIImage, _ image2: UIImage) {
    let request1 = VNGenerateImageFeaturePrintRequest()
    let request2 = VNGenerateImageFeaturePrintRequest()

    // ... perform requests ...

    let features1 = extractFeatures(from: request1)
    let features2 = extractFeatures(from: request2)

    let similarity = features1.cosineOfAngle(with: features2)
    print("Image similarity: \(similarity)")
}
```

### Real-time Search with SwiftUI

```swift
struct SearchResultsView: View {
    @State private var searchText = ""
    let documents: [[Double]]
    let embeddings: [String: [Double]]

    var filteredResults: [(index: Int, score: Double)] {
        guard !searchText.isEmpty,
              let query = searchText.tokenize()
                .embed(using: embeddings)
                .averaged() else { return [] }

        return documents.cosineSimilarities(to: query)
            .enumerated()
            .map { (index: $0.offset, score: $0.element) }
            .filter { $0.score > 0.3 }  // Relevance threshold
            .sorted { $0.score > $1.score }
    }

    var body: some View {
        List(filteredResults, id: \.index) { result in
            HStack {
                Text(documentTitles[result.index])
                Spacer()
                Text(String(format: "%.0f%%", result.score * 100))
                    .foregroundColor(.secondary)
            }
        }
        .searchable(text: $searchText)
    }
}
```

## Algorithm Complexity

| Operation | Time Complexity | Space Complexity |
|-----------|----------------|------------------|
| `cosineOfAngle(with:)` | O(d) | O(1) |
| `distance(to:)` | O(d) | O(1) |
| `cosineSimilarities(to:)` | O(n × d) | O(n) |

Where:
- `d` = vector dimensionality (e.g., 50 for GloVe 50d)
- `n` = number of vectors in database

For semantic search with 10,000 documents and 50-dimensional vectors:
- Single similarity: ~50 operations
- Batch similarities: ~500,000 operations

## See Also

- <doc:Text-Processing>
- <doc:Ranking-Operations>
- <doc:Operations>
- <doc:Matrices-Operations>

## Topics

### Similarity Metrics
- ``Swift/Array/cosineOfAngle(with:)``
- ``Swift/Array/distance(to:)``

### Batch Operations
- ``Swift/Array/cosineSimilarities(to:)-double-array``
- ``Swift/Array/cosineSimilarities(to:)-float-array``
