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

## Quick Start

### Vector Operations

```swift
import Quiver

// Vectors are just Swift arrays with linear algebra operations
let v = [3.0, 4.0]

// Find magnitude (length) using Pythagorean theorem
let magnitude = v.magnitude  // 5.0

// Create unit vector (same direction, length of 1)
let unitVector = v.normalized  // [0.6, 0.8]

// Practical example: RGB color adjustment
let color = [0.8, 0.5, 0.2]  // Amber color
let brighterColor = color * 1.2  // [0.96, 0.6, 0.24]

// Physics: Calculate work done by a force
let force = [5.0, 3.0, 2.0]
let distance = [10.0, 0.0, 0.0]
let work = force.dot(distance)  // 50.0 (only x-axis component matters)

// Machine Learning: Compare product feature vectors
let product1 = [4.2, 7.8, 3.1, 9.5]  // Price, rating, reviews, popularity
let product2 = [3.8, 8.2, 2.9, 9.7]
let similarity = product1.cosineOfAngle(with: product2)  // 0.998 (very similar!)
```

### Statistics for Swift Charts

```swift
import Quiver
import Charts

// Sales data over time
let dailySales = [45.0, 52.0, 48.0, 61.0, 55.0, 58.0, 49.0, 67.0, 72.0, 69.0]

// Statistical summary
let avgSales = dailySales.mean  // 57.6
let median = dailySales.median  // 56.5
let stdDev = dailySales.standardDeviation  // 9.1

// Smooth noisy data for trend visualization
let smoothed = dailySales.rollingAverage(window: 3)
// [45.0, 48.5, 50.3, 53.7, 58.0, 58.0, 57.3, 58.0, 62.7, 69.3]

// Find outliers for highlighting in charts
let outliers = dailySales.outlierIndices()  // [7, 8, 9] (indices of unusual spikes)

// Histogram binning for distribution charts
let binned = dailySales.histogram(bins: 5)
// Creates frequency distribution for bar charts
```

## Design Philosophy

Quiver is built on several core principles:

* **Swift-first approach**: Extends native Swift arrays rather than creating custom types
* **No conversion overhead**: Work directly with Swift arrays without type conversion
* **Educational focus**: Clear implementations that map to mathematical concepts
* **Progressive disclosure**: Simple operations are simple, complex operations are possible

## Data Science Framework

Quiver occupies a unique niche as a Swift-native data science framework with a clean, developer-friendly API. It fills the gap between low-level frameworks and high-level tools like Foundation Models. Overall, the framework provides the style and functionality of frameworks utilized in the Python community, reimagined for Swift's type system and modern language features.

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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Quiver is available under the Apache License, Version 2.0. See the LICENSE file for more info.

## Questions

Have a question? Feel free to contact me on [LinkedIn](https://www.linkedin.com/in/waynebishop).
