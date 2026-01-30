# Ranking Operations

Find top-K highest-scoring items for semantic search, recommendation systems, and k-nearest neighbors (k-NN) algorithms.

## Overview

After computing similarity scores between a query and a database (see <doc:Similarity-Operations>), we need to identify the most relevant results. Ranking operations sort scores and return the top-K items—the foundation of semantic search, recommendation engines, and nearest neighbor classification.

Quiver's ranking operations provide efficient algorithms for finding top results without sorting the entire dataset, making them suitable for large-scale applications.

## Top-K selection

The `.topIndices(k:)` method finds the K highest-scoring elements and returns their indices with scores. This is more efficient than sorting when K is much smaller than N.

```swift
let scores = [0.3, 0.9, 0.1, 0.7, 0.5]

let top3 = scores.topIndices(k: 3)
// [(index: 1, score: 0.9),
//  (index: 3, score: 0.7),
//  (index: 4, score: 0.5)]
```

The method returns:
- Array of tuples containing index and score
- Sorted in descending order (highest scores first)
- Limited to K results
- Preserves original indices for lookup

### Why use top-K instead of full sort

**Sorting all results:**
```swift
// O(n log n) - expensive for large datasets
let sorted = scores.enumerated()
    .sorted { $0.element > $1.element }
    .prefix(k)
```

**Top-K selection:**
```swift
// O(n log n) currently, but O(n log k) with heap-based optimization
let topK = scores.topIndices(k: k)
```

For large databases (n = 1M) with small result sets (k = 10), top-K selection can be significantly faster with heap-based implementations.

## Semantic search with top-K

Combine similarity computation with ranking to build semantic search:

```swift
import Quiver

// Document database (pre-computed vectors)
let database = [
    [0.8, 0.7, 0.9],  // Doc 0: "running shoes"
    [0.1, 0.2, 0.1],  // Doc 1: "laptop computer"
    [0.7, 0.8, 0.8],  // Doc 2: "jogging sneakers"
    [0.2, 0.3, 0.2],  // Doc 3: "office chair"
    [0.8, 0.6, 0.9]   // Doc 4: "athletic footwear"
]

// Search query
let query = [0.8, 0.7, 0.9]  // "running shoes for training"

// Compute similarities
let similarities = database.cosineSimilarities(to: query)
// [1.0, 0.25, 0.98, 0.31, 0.99]

// Find top 3 results
let results = similarities.topIndices(k: 3)
// [(index: 0, score: 1.0),   // Doc 0 - perfect match
//  (index: 4, score: 0.99),  // Doc 4 - very similar
//  (index: 2, score: 0.98)]  // Doc 2 - similar
```

### Complete search function

```swift
func findSimilar(query: [Double],
                 database: [[Double]],
                 topK: Int = 5) -> [(index: Int, score: Double)] {
    let similarities = database.cosineSimilarities(to: query)
    return similarities.topIndices(k: topK)
}

// Use it
let embeddings = try loadGloVe(from: "glove.6B.50d.txt")

guard let queryVector = "best running shoes"
    .tokenize()
    .embed(using: embeddings)
    .averaged() else {
    fatalError("Unable to create query vector")
}

let topResults = findSimilar(query: queryVector,
                             database: documentVectors,
                             topK: 10)
```

## K-Nearest Neighbors (k-NN)

K-NN classification finds the K most similar training examples to classify new data. Top-K ranking provides the core operation.

```swift
// Training data with labels
struct LabeledVector {
    let vector: [Double]
    let label: String
}

let trainingData = [
    LabeledVector(vector: [0.8, 0.7], label: "sports"),
    LabeledVector(vector: [0.1, 0.2], label: "tech"),
    LabeledVector(vector: [0.7, 0.8], label: "sports"),
    LabeledVector(vector: [0.2, 0.1], label: "tech"),
    LabeledVector(vector: [0.9, 0.6], label: "sports")
]

// Classify new item
func knnClassify(item: [Double],
                 training: [LabeledVector],
                 k: Int = 3) -> String {
    // Find k nearest neighbors
    let vectors = training.map { $0.vector }
    let neighbors = vectors.cosineSimilarities(to: item)
        .topIndices(k: k)

    // Count votes from neighbors
    let votes = neighbors.reduce(into: [:]) { counts, neighbor in
        let label = training[neighbor.index].label
        counts[label, default: 0] += 1
    }

    // Return most common label
    return votes.max { $0.value < $1.value }!.key
}

// Use it
let newItem = [0.75, 0.75]
let classification = knnClassify(item: newItem,
                                training: trainingData,
                                k: 3)
// "sports" (nearest neighbors are mostly sports items)
```

## Weighted k-NN

Weight neighbors by similarity score for better classification:

```swift
func weightedKNN(item: [Double],
                 training: [LabeledVector],
                 k: Int = 3) -> String {
    let vectors = training.map { $0.vector }
    let neighbors = vectors.cosineSimilarities(to: item)
        .topIndices(k: k)

    // Weight votes by similarity
    let weightedVotes = neighbors.reduce(into: [:]) { counts, neighbor in
        let label = training[neighbor.index].label
        counts[label, default: 0.0] += neighbor.score  // Use similarity as weight
    }

    return weightedVotes.max { $0.value < $1.value }!.key
}
```

This gives more influence to closer neighbors, improving classification accuracy.

## Recommendation systems

Rank items by similarity to user preferences:

```swift
// User's preference profile (average of liked items)
guard let userProfile = likedArticles.map({ $0.vector }).averaged() else {
    fatalError("Unable to create user profile from liked articles")
}

// Candidate articles
struct Article {
    let id: String
    let title: String
    let vector: [Double]
}

let candidates: [Article] = // ... load articles ...

// Rank by relevance to user
let recommendations = candidates.map { $0.vector }
    .cosineSimilarities(to: userProfile)
    .topIndices(k: 10)
    .map { result in
        (article: candidates[result.index],
         score: result.score)
    }

// Present top 10 recommendations
for (article, score) in recommendations {
    print("\(article.title) - \(Int(score * 100))% match")
}
```

## Performance optimization

### Heap-based top-K (advanced)

For very large datasets, heap-based selection can improve performance from O(n log n) to O(n log k):

```swift
// Current implementation: O(n log n)
let results = similarities.topIndices(k: k)

// Heap-based optimization: O(n log k)
// Maintains min-heap of size k, replacing minimum when better score found
// See Chapter 23 of the book for implementation details
```

The performance difference becomes significant with large N and small k:

| Documents | k | Brute-force | Heap-based | Speedup |
|-----------|---|-------------|------------|---------|
| 1,000 | 5 | O(10,000) | O(2,300) | 4.3× |
| 10,000 | 10 | O(133,000) | O(33,000) | 4.0× |
| 100,000 | 10 | O(1,660,000) | O(330,000) | 5.0× |
| 1,000,000 | 5 | O(20,000,000) | O(2,300,000) | 8.7× |

### Caching and precomputation

For static databases, precompute once:

```swift
struct SearchIndex {
    let documents: [Document]
    let vectors: [[Double]]  // Pre-computed, cached

    func search(_ query: String, embeddings: [String: [Double]]) -> [SearchResult] {
        guard let queryVector = query.tokenize()
            .embed(using: embeddings)
            .averaged() else { return [] }

        return vectors.cosineSimilarities(to: queryVector)
            .topIndices(k: 10)
            .map { result in
                SearchResult(document: documents[result.index],
                           score: result.score)
            }
    }
}

// Build index once
let index = SearchIndex(documents: allDocuments,
                       vectors: precomputedVectors)

// Fast searches (no re-computation)
let results = index.search(userQuery, embeddings: embeddings)
```

## Threshold filtering

Combine ranking with relevance thresholds:

```swift
func relevantResults(query: [Double],
                    database: [[Double]],
                    topK: Int = 10,
                    minScore: Double = 0.5) -> [(index: Int, score: Double)] {
    return database.cosineSimilarities(to: query)
        .topIndices(k: topK)
        .filter { $0.score >= minScore }
}

// Returns only results above threshold
let results = relevantResults(query: queryVector,
                             database: documentVectors,
                             topK: 20,
                             minScore: 0.6)
```

This prevents returning irrelevant results even if they're in the top K.

## Practical applications

### Duplicate detection

```swift
// Find near-duplicates in a collection
func findDuplicates(in documents: [[Double]],
                   threshold: Double = 0.95) -> [(Int, Int, Double)] {
    var duplicates: [(Int, Int, Double)] = []

    for i in 0..<documents.count {
        let similarities = documents.cosineSimilarities(to: documents[i])

        // Find highly similar documents (excluding self)
        let similar = similarities.topIndices(k: 5)
            .filter { $0.index != i && $0.score >= threshold }

        for result in similar where result.index > i {
            duplicates.append((i, result.index, result.score))
        }
    }

    return duplicates
}
```

### Multi-label classification

```swift
// Assign multiple categories based on top-K similarity
func multiLabelClassify(item: [Double],
                       training: [LabeledVector],
                       k: Int = 5,
                       threshold: Double = 0.7) -> [String] {
    let vectors = training.map { $0.vector }
    let neighbors = vectors.cosineSimilarities(to: item)
        .topIndices(k: k)
        .filter { $0.score >= threshold }

    // Return all labels above threshold
    return neighbors.map { training[$0.index].label }
        .reduce(into: Set<String>()) { $0.insert($1) }
        .sorted()
}

// Item might belong to multiple categories
let labels = multiLabelClassify(item: newsArticleVector,
                               training: trainingData,
                               k: 10,
                               threshold: 0.75)
// ["politics", "economics", "international"]
```

### Exploration vs exploitation

Balance popular items with diverse recommendations:

```swift
func diverseRecommendations(userProfile: [Double],
                           candidates: [[Double]],
                           topK: Int = 10,
                           diversityFactor: Double = 0.2) -> [(index: Int, score: Double)] {
    let similarities = candidates.cosineSimilarities(to: userProfile)
        .topIndices(k: topK * 2)  // Get more candidates

    // Mix top results with diverse alternatives
    let topN = Int(Double(topK) * (1.0 - diversityFactor))
    let diverseN = topK - topN

    let top = Array(similarities.prefix(topN))
    let diverse = similarities.dropFirst(topN)
        .shuffled()
        .prefix(diverseN)

    return (top + diverse).sorted { $0.score > $1.score }
}
```

## For Python developers

Quiver's ranking matches NumPy and scikit-learn workflows:

**Python (NumPy):**
```python
import numpy as np

# Top-K indices
top_k = np.argsort(scores)[::-1][:k]
top_scores = scores[top_k]

# With scores
results = [(idx, scores[idx]) for idx in top_k]
```

**Swift (Quiver):**
```swift
let results = scores.topIndices(k: k)
// Already returns [(index, score)] tuples
```

**Python (scikit-learn k-NN):**
```python
from sklearn.neighbors import NearestNeighbors

nn = NearestNeighbors(n_neighbors=5)
nn.fit(training_vectors)
distances, indices = nn.kneighbors([query])
```

**Swift (Quiver):**
```swift
let neighbors = trainingVectors
    .cosineSimilarities(to: query)
    .topIndices(k: 5)
```

## For iOS developers

### SwiftUI Search Results

```swift
struct SearchResultsView: View {
    let results: [(index: Int, score: Double)]
    let documents: [Document]

    var body: some View {
        List(results, id: \.index) { result in
            VStack(alignment: .leading) {
                Text(documents[result.index].title)
                    .font(.headline)

                HStack {
                    Text(documents[result.index].snippet)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(result.score * 100))%")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
```

### Real-time filtering

```swift
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var results: [(index: Int, score: Double)] = []

    let database: [[Double]]
    let embeddings: [String: [Double]]

    func search() {
        guard !searchText.isEmpty,
              let query = searchText.tokenize()
                .embed(using: embeddings)
                .averaged() else {
            results = []
            return
        }

        results = database.cosineSimilarities(to: query)
            .topIndices(k: 20)
            .filter { $0.score > 0.3 }  // Relevance threshold
    }
}
```

### CoreML Integration

```swift
import CoreML

func findSimilarImages(to query: UIImage,
                      in database: [UIImage],
                      model: VNCoreMLModel,
                      k: Int = 5) -> [(index: Int, score: Double)] {
    let queryFeatures = extractFeatures(from: query, model: model)
    let databaseFeatures = database.map { extractFeatures(from: $0, model: model) }

    return databaseFeatures.cosineSimilarities(to: queryFeatures)
        .topIndices(k: k)
}
```

## Algorithm complexity

| Operation | Time | Space | Notes |
|-----------|------|-------|-------|
| `topIndices(k:)` | O(n log n) | O(n) | Current implementation |
| Heap-based top-K | O(n log k) | O(k) | Advanced optimization |
| With similarity | O(n×d + n log n) | O(n) | d = vector dimensions |

For typical semantic search:
- n = 10,000 documents
- d = 50 dimensions (GloVe)
- k = 10 results
- Total: ~600,000 operations (very fast)

## See also

- <doc:Similarity-Operations>
- <doc:Text-Processing>
- <doc:Operations>
- <doc:Matrices-Operations>

## Topics

### Top-K selection
- ``Swift/Array/topIndices(k:)``

### Related operations
- ``Swift/Array/cosineSimilarities(to:)-double-array``
- ``Swift/Array/cosineOfAngle(with:)``
