# Quiver: Swift Vector Mathematics and Numerical Computing

Quiver is a Swift package that provides powerful numerical computing capabilities for Swift applications. This lightweight, functional and educational framework extends Swift's native `Array` type with vector operations, statistical functions, and array manipulation tools.

## Features

* **Vector Operations**
  * Element-wise arithmetic operations (+, -, *, /)
  * Dot product, magnitude, normalization
  * Angle calculations and vector projections
  * Matrix operations (multiplication, transpose, inverse)

* **Similarity and Distance Operations**
  * Cosine similarity (single and batch)
  * Euclidean distance
  * Top-K selection with labels
  * Duplicate detection and cluster analysis

* **Statistical Functions**
  * Basic statistics (mean, median, min, max, argmin, argmax)
  * Variance and standard deviation
  * Cumulative operations (sum, product)
  * Outlier detection (z-score method)
  * Vector averaging (meanVector)

* **Array Generation and Manipulation**
  * Generate arrays (zeros, ones, linspace, random)
  * Create special matrices (identity, diagonal)
  * Shape information and transformation
  * Sorting and ranking (sortedIndices)

* **Data Visualization Tools**
  * Swift Charts integration (rolling averages, histograms)
  * Percentiles and quartiles for box plots
  * Grouped aggregations and percentage changes

* **Data Analysis Tools**
  * Boolean operations and filtering
  * Broadcasting operations (scalar and vector)
  * Comparison operations and masking

## Simple Example

```swift
import Quiver

// Find semantically similar words using vector embeddings
let embeddings: [String: [Double]] = [
    "king": [0.50, 0.83, 0.32],
    "queen": [0.58, 0.79, 0.41],
    "man": [0.31, 0.22, 0.15],
    "car": [0.12, 0.91, 0.67]
]

let query = embeddings["king", default: []]
let candidates = ["queen", "man", "car"]
let vectors = candidates.compactMap { embeddings[$0] }

// Compute similarity and rank results
let results = query
    .cosineSimilarities(to: vectors)
    .topIndices(k: 1, labels: candidates)

print(results.first ?? (label: "", score: 0.0))
// Output: (label: "queen", score: 0.96)
```

## Design Philosophy

Quiver is built on several core principles:

* **Swift-first approach**: Extends native Swift arrays rather than creating custom types
* **No conversion overhead**: Work directly with Swift arrays without type conversion
* **Educational focus**: Clear implementations that map to mathematical concepts
* **Progressive disclosure**: Simple operations are simple, complex operations are possible

## Data Science Framework

Quiver occupies a unique niche as a Swift-native data science framework with a clean, developer-friendly API. It fills the gap between low-level frameworks and high-level tools like Core ML and Foundation Models. Overall, the framework provides the style and functionality of frameworks utilized in the Python community, reimagined for Swift's type system and modern language features.


## When to Use Quiver

Quiver is particularly useful for:

* **AI/ML applications** - Semantic search, similarity analysis, word prediction, and recommendation systems
* **Game developers** - Physics simulations, collision detection, pathfinding, and spatial calculations
* **Data visualization** - Projects using Swift Charts with statistical operations and aggregations
* **Educational settings** - Teaching vector mathematics, numerical computing, and data science concepts
* **On-device intelligence** - Privacy-first ML features without cloud dependencies or external runtimes

## Swift Charts Integration

Quiver seamlessly integrates with Swift Charts for data visualization:
* Rolling averages for time series smoothing
* Histogram binning for distribution analysis
* Percentiles and quartiles for box plots
* Grouped aggregations for bar charts
* Percentage change and correlation analysis

## Documentation

Comprehensive documentation is available including:
* Vector operation guides
* Statistical function references
* Linear algebra primer for beginners
* Swift Charts integration examples

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Quiver is available under the Apache License, Version 2.0. See the LICENSE file for more info.

## Questions

Have a question? Feel free to contact me on [LinkedIn](https://www.linkedin.com/in/waynebishop).
