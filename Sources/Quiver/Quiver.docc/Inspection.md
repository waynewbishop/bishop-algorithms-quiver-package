# Data Inspection

Examine the structure and characteristics of your arrays and matrices.

## Overview

Quiver provides methods to inspect and understand your data, helping you visualize array characteristics during development and debugging. These inspection tools make it easy to understand the dimensions, type, and statistical properties of your data.

### Shape Information

The `shape` property returns the dimensions of an array in a NumPy-like format:

```swift
let vector = [1, 2, 3, 4]
print(vector.shape)  // (4, 0)

let matrix = [[1, 2, 3], [4, 5, 6]]
print(matrix.shape)  // (2, 3)
```

For vectors (1D arrays), the second dimension is 0, which distinguishes them from 1-row matrices. For matrices (2D arrays), the shape represents (rows, columns).

You can also check if an array represents a valid matrix:

```swift
let validMatrix = [[1, 2], [3, 4]]
print(validMatrix.isMatrix)  // true

let invalidMatrix = [[1, 2], [3, 4, 5]]
print(invalidMatrix.isMatrix)  // false - rows have different lengths
```

### The `info()` Method

For a more comprehensive overview, the `info()` method provides shape information along with type details, statistical summaries, and a preview of the data:

```swift
// For vectors (1D arrays)
let vector = [3.5, 1.8, 4.2, 2.7, 5.1]
print(vector.info())
// Output:
// Array Information:
// Count: 5
// Shape: (5, 0)
// Type: Double.Type
// Mean: 3.46
// Min: 1.8
// Max: 5.1
//
// First 5 items:
// [0]: 3.5
// [1]: 1.8
// [2]: 4.2
// [3]: 2.7
// [4]: 5.1

// For matrices (2D arrays)
let matrix = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]]
print(matrix.info())
// Output:
// Array Information:
// Count: 3
// Shape: (3, 2)
// Type: Array<Double>.Type
//
// First 3 items:
// [0]: [1.0, 2.0]
// [1]: [3.0, 4.0]
// [2]: [5.0, 6.0]
```

### When to Use These Methods

These inspection methods serve different purposes:

- Use `shape` when you only need dimension information, particularly in functions that operate on arrays of specific shapes
- Use `isMatrix` to validate that a 2D array has consistent row lengths before performing matrix operations
- Use `info()` when you want a comprehensive overview including shape, type, statistics, and a preview of the contents

### Workflow Integration

Integrating these methods into your workflow can improve productivity and code clarity:

```swift
// Load data
let data = loadData()

// Inspect the data structure
print(data.info())

// Validate before operations
guard data.isMatrix else {
    print("Error: Data is not a valid matrix")
    return
}

// Use shape information in processing
let (rows, columns) = data.shape
print("Processing \(rows) rows and \(columns) columns")
```

### Implementation Details

These inspection methods are implemented as properties and functions on Array extensions with appropriate type constraints:

- The `shape` property works on arrays of any element type
- The `isMatrix` property works on arrays of any element type
- The `info()` method is overloaded to provide appropriate information based on the array's element type:
  - For general numeric arrays: Shows count, shape, type, and contents
  - For floating-point arrays: Adds statistical information (mean, min, max)

## Topics

### Inspection Properties
- ``Swift/Array/shape``
- ``Swift/Array/isMatrix``
- ``Swift/Array/matrixDimensions``

### Inspection Methods
- ``Swift/Array/info()-44fcx``

### Related Articles
- <doc:Statistics>
- <doc:Shape>
```
