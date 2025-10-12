# Shape and Dimensions

Get information about array dimensions and manipulate array shapes.

## Overview

Quiver provides methods to query and manipulate the shape of arrays, letting you examine dimensions, check if an array represents a matrix, and reshape arrays to different configurations.

Shape operations are essential for data preparation and mathematical transformations, particularly when working with multi-dimensional data.

### Inspecting Dimensions

Quiver adds properties and methods to arrays that let you examine their dimensions:

```swift
let vector = [1, 2, 3, 4]
let matrix = [[1, 2, 3], [4, 5, 6]]

// Get shape information
vector.shape  // (4, 0) for a vector
matrix.shape  // (2, 3) for a matrix

// Check matrix properties
matrix.isMatrix  // true
matrix.matrixDimensions  // Optional(rows: 2, columns: 3)
```

> Tip: For vectors, the `shape` property returns a tuple where the second value is 0, distinguishing it from a one-row matrix.

### Validating Matrices

Quiver helps you verify if an array represents a valid matrix (all rows must have the same length):

```swift
let validMatrix = [[1, 2, 3], [4, 5, 6]]
validMatrix.isMatrix  // true

let invalidMatrix = [[1, 2], [3, 4, 5]]
invalidMatrix.isMatrix  // false - rows have different lengths
```

> Warning: Many matrix operations require valid matrices with consistent row lengths. Use `isMatrix` to validate before performing such operations.

### Transposing Matrices

Transposing is a special reshape operation that flips a matrix over its diagonal:

```swift
let matrix = [[1, 2, 3], [4, 5, 6]]
let transposed = matrix.transpose()  // [[1, 4], [2, 5], [3, 6]]

// Or use the Swift naming convention alias
let transposed2 = matrix.transposed()  // [[1, 4], [2, 5], [3, 6]]
```

This operation is particularly useful in linear algebra and data transformations.

### Extracting Columns

Swift makes it easy to extract rows from matrices using subscripts, but extracting columns requires mapping. Quiver provides a convenient method for this common operation:

```swift
let gameScores = [
    [95, 88, 92, 91],  // Player A's scores
    [87, 90, 89, 93],  // Player B's scores
    [92, 94, 88, 96]   // Player C's scores
]

// Extract all scores from game 3 (index 2)
let game3Scores = gameScores.column(at: 2)  // [92, 89, 88]

// Compare with extracting a row (built-in)
let playerAScores = gameScores[0]  // [95, 88, 92, 91]
```

> Tip: Use `.column(at:)` when you need vertical slices of data from matrices, such as time-series data points or feature extraction in machine learning.

## Implementation Details

Shape operations in Quiver are designed to be intuitive and familiar to users of other numerical computing libraries like NumPy:

- Shape information is provided through computed properties
- Shape validation uses Swift's type system where possible
- Reshape operations create new arrays (they don't modify the original)

> Note: Unlike NumPy, Quiver works with Swift's nested arrays for multi-dimensional data. A matrix is represented as an array of arrays, not a specialized matrix type.

## Topics

### Shape Properties
- ``Swift/Array/shape``
- ``Swift/Array/isMatrix``
- ``Swift/Array/matrixDimensions``

### Matrix Transformations
- ``Swift/Array/transpose()``
- ``Swift/Array/transposed()``
- ``Swift/Array/column(at:)``

### Related Articles
- <doc:Elements>
- <doc:Operations>
