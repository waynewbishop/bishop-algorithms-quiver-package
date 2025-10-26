# Matrix Operations

Work with matrices using transpose and column extraction operations.

## Overview

Quiver extends Swift arrays to support common matrix operations, making it easy to work with two-dimensional data structures. When working with matrices (arrays of arrays), Quiver provides convenient methods for transformations and data extraction.

### Transposing Matrices

Transposing flips a matrix across its diagonal, converting rows to columns and columns to rows:

```swift
let matrix = [[1, 2, 3], [4, 5, 6]]
let transposed = matrix.transpose()  // [[1, 4], [2, 5], [3, 6]]

// Or use the Swift naming convention alias
let transposed2 = matrix.transposed()  // [[1, 4], [2, 5], [3, 6]]
```

This operation is essential in linear algebra, data reorganization, and machine learning applications where you need to change the orientation of your data.

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

Matrix operations in Quiver are designed to work seamlessly with Swift's array types:

- Operations work on arrays of arrays (2D arrays)
- All operations create new arrays rather than modifying the original
- Methods follow Swift naming conventions (e.g., `transposed()` alongside `transpose()`)

> Note: Quiver represents matrices as nested Swift arrays. A matrix is simply an array of arrays, not a specialized matrix type. This makes it easy to integrate with existing Swift code.

## Related Articles
- <doc:Elements>
- <doc:Operations>
