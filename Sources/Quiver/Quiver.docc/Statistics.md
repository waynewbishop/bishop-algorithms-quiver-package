# Basic Statistics

Calculate common statistical measures from arrays of numerical data.

## Overview

Quiver extends Swift arrays with powerful statistical functions that let you calculate summary statistics like sum, mean, median, variance, and standard deviation. These operations support both exploratory data analysis and algorithmic computations.

Statistical functions form the foundation of data analysis and are essential for understanding the characteristics of your numerical data.

### Aggregation Functions

Quiver provides functions to calculate basic aggregations on arrays:

```swift
let data = [4.0, 7.0, 2.0, 9.0, 3.0]

// Calculate the sum of all elements
let total = data.sum()  // 25.0

// Find the minimum and maximum values
let smallest = data.min()  // 2.0
let largest = data.max()  // 9.0

// Find the indices of minimum and maximum values
let minIndex = data.argmin()  // 2
let maxIndex = data.argmax()  // 3
```

> Tip: Use `argmin()` and `argmax()` when you need to know not just the extreme values but also where they occur in your data.

### Central Tendency

These functions help you find the "center" of your data distribution:

```swift
let data = [4.0, 7.0, 2.0, 9.0, 3.0]

// Calculate the mean (average)
let mean = data.mean()  // 5.0

// Calculate the median (middle value)
let median = data.median()  // 4.0
```

> Note: The mean is affected by extreme values (outliers), while the median is more robust. Comparing these two measures can help identify skewed distributions.

### Dispersion and Variation

These functions help you understand how spread out your data is:

```swift
let data = [4.0, 7.0, 2.0, 9.0, 3.0]

// Calculate the variance
let variance = data.variance()  // 8.0

// Calculate the standard deviation
let std = data.std()  // 2.83...

// For sample statistics (n-1 denominator)
let sampleVar = data.variance(ddof: 1)  // 10.0
let sampleStd = data.std(ddof: 1)  // 3.16...
```

> Important: The `ddof` parameter (Delta Degrees of Freedom) changes how variance is calculated. Use `ddof: 0` for population statistics and `ddof: 1` for sample statistics. Sample statistics are more commonly used when your data represents only a subset of all possible observations.

### Cumulative Operations

Calculate cumulative statistics across your array:

```swift
let data = [1.0, 2.0, 3.0, 4.0, 5.0]

// Calculate cumulative sum
let cumSum = data.cumulativeSum()  // [1.0, 3.0, 6.0, 10.0, 15.0]

// Calculate cumulative product
let cumProd = data.cumulativeProduct()  // [1.0, 2.0, 6.0, 24.0, 120.0]
```

Cumulative operations are useful for:
- Running totals and balances
- Calculating growth over time
- Building empirical distribution functions

### Working with Different Data Types

Quiver's statistical functions have appropriate type constraints:

```swift
// Basic operations work with any Numeric type
let integers = [1, 2, 3, 4, 5]
let intSum = integers.sum()  // 15

// Advanced statistics require FloatingPoint types
let doubles = [1.0, 2.0, 3.0, 4.0, 5.0]
let mean = doubles.mean()  // 3.0
```

> Note: If you need to perform statistical operations on integer data, consider converting to a floating-point type first to avoid precision loss.

## Common Use Cases

### Descriptive Statistics

Generate a statistical summary of your data:

```swift
let data = [12.5, 18.3, 9.8, 15.2, 13.7, 10.1, 19.4]

let stats = """
    Count: \(data.count)
    Sum: \(data.sum())
    Mean: \(data.mean()!)
    Median: \(data.median()!)
    Min: \(data.min()!)
    Max: \(data.max()!)
    Range: \(data.max()! - data.min()!)
    Variance: \(data.variance()!)
    Std Dev: \(data.std()!)
    """
```

### Data Normalization

Normalize data to have specific statistical properties:

```swift
let data = [4.0, 7.0, 2.0, 9.0, 3.0]

// Z-score normalization (mean = 0, std = 1)
let mean = data.mean()!
let std = data.std()!
let zScores = data.map { ($0 - mean) / std }

// Min-max scaling (range 0 to 1)
let min = data.min()!
let max = data.max()!
let scaled = data.map { ($0 - min) / (max - min) }
```

### Anomaly Detection

Find values that deviate significantly from the norm:

```swift
let data = [4.0, 7.0, 2.0, 9.0, 3.0, 35.0, 5.0]

let mean = data.mean()!
let std = data.std()!

// Find outliers (values more than 2 standard deviations from mean)
let outlierThreshold = 2.0
let isOutlier = data.map { abs($0 - mean) > outlierThreshold * std }
// [false, false, false, false, false, true, false]

// Extract outlier values
let outliers = data.masked(by: isOutlier)  // [35.0]
```

## Implementation Details

Quiver implements statistical functions as extensions to the `Array` type with appropriate type constraints:

- Basic operations like `sum()` and `product()` are available for any `Numeric` element type
- Operations requiring comparison like `min()` and `max()` require `Comparable` elements
- Advanced statistics like `mean()` and `variance()` require `FloatingPoint` elements

This approach provides a natural and intuitive API that works directly with Swift's native arrays.

## Topics

### Basic Aggregations
- ``Swift/Array/sum()``
- ``Swift/Array/product()``
- ``Swift/Array/min()``
- ``Swift/Array/max()``
- ``Swift/Array/argmin()``
- ``Swift/Array/argmax()``

### Central Tendency
- ``Swift/Array/mean()``
- ``Swift/Array/median()``

### Dispersion Measures
- ``Swift/Array/variance(ddof:)``
- ``Swift/Array/std(ddof:)``

### Cumulative Statistics
- ``Swift/Array/cumulativeSum()``
- ``Swift/Array/cumulativeProduct()``

### Related Articles
- <doc:Boolean>
