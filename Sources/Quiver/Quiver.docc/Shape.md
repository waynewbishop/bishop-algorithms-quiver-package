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

### Reshaping Arrays

Reshape operations let you transform an array into a new shape while preserving its elements:

```swift
let data = [1, 2, 3, 4, 5, 6]

// Reshape to a 2×3 matrix
let reshaped = data.reshape(2, 3)  // [[1, 2, 3], [4, 5, 6]]

// Reshape to a 3×2 matrix
let transposed = data.reshape(3, 2)  // [[1, 2], [3, 4], [5, 6]]
```

> Important: When reshaping, the total number of elements must remain the same. For example, you can reshape a 12-element array into shapes like 3×4, 4×3, 2×6, etc., but not into a 3×5 shape.

### Transposing Matrices

Transposing is a special reshape operation that flips a matrix over its diagonal:

```swift
let matrix = [[1, 2, 3], [4, 5, 6]]
let transposed = matrix.transpose()  // [[1, 4], [2, 5], [3, 6]]
```

This operation is particularly useful in linear algebra and data transformations.

## Implementation Details

Shape operations in Quiver are designed to be intuitive and familiar to users of other numerical computing libraries like NumPy:

- Shape information is provided through computed properties
- Shape validation uses Swift's type system where possible
- Reshape operations create new arrays (they don't modify the original)

> Note: Unlike NumPy, Quiver works with Swift's nested arrays for multi-dimensional data. A matrix is represented as an array of arrays, not a specialized matrix type.
