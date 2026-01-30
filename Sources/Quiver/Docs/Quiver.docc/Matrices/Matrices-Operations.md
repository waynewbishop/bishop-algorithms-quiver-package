# Matrix Operations

Work with two-dimensional arrays (matrices) using element-wise arithmetic and transformations.

## Overview

A **matrix** is a rectangular grid of numbers arranged in rows and columns. While a `vector` is a single list of numbers representing a point or direction in space, a matrix is a collection of multiple vectors organized together. Quiver extends Swift's `Array` type to support matrix operations on nested arrays. Matrices represent tabular data, transformations, and multi-dimensional datasets. 

> Tip: For detailed coverage of matrix concepts with visualizations and examples, see [Matrices](https://waynewbishop.github.io/swift-algorithms/21-matrices.html) in Swift Algorithms & Data Structures.

### Creating matrices

```swift
import Quiver

// Simple 2×3 matrix
let matrix = [
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0]
]

// Access elements
let value = matrix[0][1]  // 2.0 (row 0, column 1)

// Access rows
let firstRow = matrix[0]  // [1.0, 2.0, 3.0]

// Access columns (using Quiver)
let secondColumn = matrix.column(at: 1)  // [2.0, 5.0]
```

### Element-wise arithmetic

Matrix arithmetic operations work element-by-element:

```swift
let m1 = [[1.0, 2.0], [3.0, 4.0]]
let m2 = [[5.0, 6.0], [7.0, 8.0]]

let sum = m1 + m2         // [[6.0, 8.0], [10.0, 12.0]]
let difference = m1 - m2  // [[-4.0, -4.0], [-4.0, -4.0]]
let product = m1 * m2     // [[5.0, 12.0], [21.0, 32.0]] (Hadamard)
let quotient = m1 / m2    // [[0.2, 0.33...], [0.42..., 0.5]]
```

> Important: The `*` operator performs **element-wise** multiplication (Hadamard product), not matrix multiplication. For [dot product](<doc:Fundamentals>) matrix multiplication, use `.multiplyMatrix()`.

### Scalar broadcasting

Apply a scalar value to every element:

```swift
let matrix = [[100.0, 200.0], [300.0, 400.0]]

// All operations work with scalars
let scaled = matrix * 0.5        // [[50.0, 100.0], [150.0, 200.0]]
let shifted = matrix + 10.0      // [[110.0, 210.0], [310.0, 410.0]]
let divided = matrix / 100.0     // [[1.0, 2.0], [3.0, 4.0]]

// Commutative operations work both ways
let doubled = 2.0 * matrix       // Same as matrix * 2.0
let offset = 5.0 + matrix        // Same as matrix + 5.0
```

### Common patterns

**Data standardization (z-score):**
```swift
let data = [[100.0, 200.0], [300.0, 400.0]]
let mean = 250.0
let stdDev = 129.0
let standardized = (data - mean) / stdDev
```

**Feature scaling (min-max):**
```swift
let features = [[1.0, 5.0], [3.0, 7.0]]
let min = 1.0
let max = 7.0
let scaled = (features - min) / (max - min)
```

**Applying transformations:**
```swift
let measurements = [[10.0, 20.0], [30.0, 40.0]]
let calibrated = measurements * 1.05 + 2.0  // 5% increase + 2.0 offset
```

### Transpose

Flip rows and columns:

```swift
let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
let transposed = matrix.transpose()
// Result: [[1.0, 4.0], [2.0, 5.0], [3.0, 6.0]]
```

### Matrix multiplication

For true matrix multiplication (dot product), use `.multiplyMatrix()`:

```swift
let a = [[1.0, 2.0], [3.0, 4.0]]
let b = [[5.0, 6.0], [7.0, 8.0]]
let product = a.multiplyMatrix(b)
// Result: [[19.0, 22.0], [43.0, 50.0]]
```

### Working with data

Matrices naturally represent tabular data:

```swift
// Game scores: rows = players, columns = games
let scores = [
    [95.0, 88.0, 92.0],  // Player A
    [87.0, 90.0, 89.0],  // Player B
    [92.0, 94.0, 88.0]   // Player C
]

// Extract all scores from game 2
let game2Scores = scores.column(at: 1)  // [88.0, 90.0, 94.0]

// Calculate average for Player B
let playerB = scores[1]
let average = playerB.mean() ?? 0.0  // 88.67
```

### Document-term matrices

Matrices organize text data for analysis:

```swift
// Document-term matrix: rows = documents, columns = words
let documents = [
    [2.0, 3.0, 1.0],  // Doc 1: word counts
    [1.0, 2.0, 3.0],  // Doc 2: word counts
    [3.0, 1.0, 2.0]   // Doc 3: word counts
]

// Analyze how often word 1 appears across documents
let word1Usage = documents.column(at: 0)  // [2.0, 1.0, 3.0]

// Switch to term-document orientation
let byTerms = documents.transpose()
```

### Type support

Matrix operations work with both `Double` and `Float` types:

```swift
let doubleMatrix: [[Double]] = [[1.0, 2.0], [3.0, 4.0]]
let floatMatrix: [[Float]] = [[1.0, 2.0], [3.0, 4.0]]

// Both support full operator syntax
let result1 = doubleMatrix * 2.0
let result2 = floatMatrix * 2.0
```

### Preconditions

- **Element-wise operations**: Matrices must have same dimensions (rows × columns)
- **Matrix multiplication**: Inner dimensions must match (n×k) × (k×m)
- **Division**: Divisor cannot contain zero elements
- **Column access**: Index must be within column count

### NumPy Compatibility

Quiver's matrix operations match NumPy's behavior:
- Element-wise operations are the default for `+`, `-`, `*`, `/`
- Scalar broadcasting works automatically
- Clean operator syntax without method calls

This makes Quiver familiar to data science practitioners transitioning from Python to Swift.

## See also

- <doc:Operations>
