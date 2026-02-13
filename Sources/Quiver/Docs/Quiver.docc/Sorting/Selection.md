# Selection

Select top-K largest or smallest elements from arrays by value.

## Overview

Sorting operations identify the highest or lowest-scoring elements in an array and return their indices with values. The `.topIndices(k:)` method provides efficient top-K selection analogous to NumPy's `argpartition` combined with sorting.

> Tip: For computing scores to sort (like cosine similarity or distance), see <doc:Similarity-Operations>.

## Sorting indices

Get the indices that would sort an array without modifying the original:

```swift
let values = [40.0, 10.0, 30.0, 20.0]
let indices = values.sortedIndices()
// [1, 3, 2, 0]

// Use indices to access elements in sorted order
let sorted = indices.map { values[$0] }
// [10.0, 20.0, 30.0, 40.0]
```

**Returns:**
- Array of indices representing sorted order
- Original array remains unchanged
- Useful when you need to sort multiple related arrays by the same order

### When to use sortedIndices

Use `sortedIndices()` when you need to:
- Sort one array and apply the same ordering to related arrays
- Track the original positions of sorted elements
- Implement custom sorting algorithms that work with indices
- Maintain correspondence between parallel arrays

**NumPy equivalent:**
```python
import numpy as np
values = np.array([40.0, 10.0, 30.0, 20.0])
indices = np.argsort(values)  # [1 3 2 0]
```

## Top-K selection

Find the K largest elements and their indices:

```swift
let scores = [0.3, 0.9, 0.1, 0.7, 0.5]

let top3 = scores.topIndices(k: 3)
// [(index: 1, score: 0.9),
//  (index: 3, score: 0.7),
//  (index: 4, score: 0.5)]
```

**Returns:**
- Array of tuples containing index and value
- Sorted in descending order (largest values first)
- Limited to K results
- Preserves original indices for element lookup

## When to use top-K

For large arrays (n = 1M) where you need only a small result set (k = 10), top-K selection is more efficient than full sorting when using heap-based implementations.

**Current implementation:** `O(n log n)`
**Heap-based optimization:** `O(n log k)` - future improvement

## Basic examples

### Finding highest values

```swift
let measurements = [23.5, 18.2, 45.1, 12.7, 38.9, 29.3]

let highest3 = measurements.topIndices(k: 3)
// [(index: 2, score: 45.1),
//  (index: 4, score: 38.9),
//  (index: 5, score: 29.3)]

// Access original elements
for result in highest3 {
    print("Index \(result.index): \(result.score)")
}
```

### Filtering by threshold

Combine selection with value filtering:

```swift
let values = [0.2, 0.8, 0.3, 0.95, 0.1, 0.75]

let topValues = values.topIndices(k: 10)
    .filter { $0.score >= 0.5 }
// [(index: 3, score: 0.95),
//  (index: 1, score: 0.8),
//  (index: 5, score: 0.75)]
```

### Finding positions of maxima

Get indices of largest elements for further processing:

```swift
let data = [5.2, 8.7, 3.1, 9.4, 6.8]

let topIndices = data.topIndices(k: 2).map { $0.index }
// [3, 1] - positions of 9.4 and 8.7

// Use indices to access related data
let topElements = topIndices.map { data[$0] }
// [9.4, 8.7]
```

## Working with multiple arrays

### Top-K with labels

Combine top-K selection with label mapping in one step:

```swift
let scores = [0.3, 0.9, 0.1, 0.7]
let labels = ["A", "B", "C", "D"]

let ranked = scores.topIndices(k: 2, labels: labels)
// [(label: "B", score: 0.9), (label: "D", score: 0.7)]
```

This convenience method eliminates manual index mapping and is particularly useful for word prediction, recommendation systems, and scenarios requiring both scores and associated labels:

```swift
// Word prediction example
let similarities = [0.92, 0.45, 0.87, 0.33, 0.78]
let candidateWords = ["sat", "ran", "on", "dog", "mat"]

let predictions = similarities.topIndices(k: 3, labels: candidateWords)
// [(label: "sat", score: 0.92),
//  (label: "on", score: 0.87),
//  (label: "mat", score: 0.78)]
```

### Sorting one array based on another

```swift
let scores = [0.3, 0.9, 0.1, 0.7]
let labels = ["A", "B", "C", "D"]

let ranked = scores.topIndices(k: 4)
    .map { (label: labels[$0.index], score: $0.score) }
// [("B", 0.9), ("D", 0.7), ("A", 0.3), ("C", 0.1)]
```

### Parallel array selection

```swift
struct DataPoint {
    let value: Double
    let metadata: String
}

let values = [2.3, 5.7, 1.8, 4.2]
let metadata = ["first", "second", "third", "fourth"]

let top2 = values.topIndices(k: 2)
    .map { idx in
        DataPoint(
            value: values[idx.index],
            metadata: metadata[idx.index]
        )
    }
// [DataPoint(5.7, "second"), DataPoint(4.2, "fourth")]
```

## For Python developers

Quiver's `topIndices(k:)` combines NumPy's `argsort` with array slicing:

**Python (NumPy):**
```python
import numpy as np

scores = np.array([0.3, 0.9, 0.1, 0.7, 0.5])

# Get top-K indices (requires reverse and slice)
top_k_indices = np.argsort(scores)[::-1][:3]
# [1, 3, 4]

# Get values
top_k_values = scores[top_k_indices]
# [0.9, 0.7, 0.5]

# Create tuples manually
results = [(idx, scores[idx]) for idx in top_k_indices]
# [(1, 0.9), (3, 0.7), (4, 0.5)]
```

**Swift (Quiver):**
```swift
let scores = [0.3, 0.9, 0.1, 0.7, 0.5]

let results = scores.topIndices(k: 3)
// [(index: 1, score: 0.9),
//  (index: 3, score: 0.7),
//  (index: 4, score: 0.5)]
```

NumPy's `argpartition` provides `O(n)` partitioning without full sorting, similar to Quiver's future heap-based optimization:

**Python (argpartition):**
```python
# Partition: elements < k-th are before, elements > k-th are after
indices = np.argpartition(scores, -3)[-3:]  # Last 3 indices
# Not guaranteed sorted: [4, 1, 3] or [3, 4, 1], etc.

# Sort the partition
sorted_indices = indices[np.argsort(scores[indices])][::-1]
# [1, 3, 4]
```

**Swift (Quiver future optimization):**
```swift
// Future O(n log k) heap-based implementation
let results = scores.topIndices(k: 3)
// Already returns sorted results
```

## Algorithm complexity

| Operation | Time | Space | Notes |
|-----------|------|-------|-------|
| `topIndices(k:)` | O(n log n) | O(n) | Current implementation |
| Heap-based top-K | O(n log k) | O(k) | Future optimization |
| Full sort + slice | O(n log n) | O(n) | Equivalent to current |

For typical use (10,000 elements, k=10): ~130,000 operations (very fast).

## See also

- <doc:Similarity-Operations> - Distance metrics for computing scores
- <doc:Statistics> - Statistical measures (mean, max, min)
- <doc:Operations> - Vector operations

## Topics

### Sorting operations
- ``Swift/Array/sortedIndices()``

### Top-K selection
- ``Swift/Array/topIndices(k:)``
- ``Swift/Array/topIndices(k:labels:)``
