# Broadcasting Operations

Apply operations between arrays and scalars or between arrays of different dimensions.

## Overview

Quiver provides broadcasting capabilities that let you perform operations between arrays and scalars, or between arrays of different shapes. Broadcasting allows you to write cleaner, more expressive code by eliminating explicit loops for common element-wise operations.

Broadcasting in Quiver follows principles similar to NumPy, making operations between arrays of different shapes intuitive and concise.

### Scalar Broadcasting

The simplest form of broadcasting applies a scalar operation to every element in an array:

```swift
let vector = [1.0, 2.0, 3.0, 4.0]

// Add a scalar to each element
let increased = vector.broadcast(adding: 5.0)  // [6.0, 7.0, 8.0, 9.0]

// Multiply each element by a scalar
let scaled = vector.broadcast(multiplyingBy: 2.0)  // [2.0, 4.0, 6.0, 8.0]

// Subtract a scalar from each element
let decreased = vector.broadcast(subtracting: 1.0)  // [0.0, 1.0, 2.0, 3.0]

// Divide each element by a scalar (floating-point only)
let divided = vector.broadcast(dividingBy: 2.0)  // [0.5, 1.0, 1.5, 2.0]
```

> Tip: Broadcasting operations create new arrays without modifying the original, maintaining Swift's value semantics.

### Matrix-Vector Broadcasting

Broadcasting also allows operations between matrices (2D arrays) and vectors:

```swift
let matrix = [[1.0, 2.0, 3.0], 
              [4.0, 5.0, 6.0]]

let rowVector = [10.0, 20.0, 30.0]
let columnVector = [100.0, 200.0]

// Add a row vector to each row
let rowBroadcast = matrix.broadcast(addingToEachRow: rowVector)
// [[11.0, 22.0, 33.0], 
//  [14.0, 25.0, 36.0]]

// Add a column vector to each column
let columnBroadcast = matrix.broadcast(addingToEachColumn: columnVector)
// [[101.0, 102.0, 103.0], 
//  [204.0, 205.0, 206.0]]

// Multiply each row by a vector
let rowMultiply = matrix.broadcast(multiplyingEachRowBy: rowVector)
// [[10.0, 40.0, 90.0], 
//  [40.0, 100.0, 180.0]]

// Multiply each column by a vector
let columnMultiply = matrix.broadcast(multiplyingEachColumnBy: columnVector)
// [[100.0, 200.0, 300.0], 
//  [800.0, 1000.0, 1200.0]]
```

> Important: When broadcasting vectors across matrices, the dimensions must be compatible. Row vectors must have the same length as matrix columns, and column vectors must have the same length as matrix rows.

### Custom Broadcasting Operations

For more flexibility, Quiver provides custom broadcasting operations with closures:

```swift
let vector = [1, 2, 3, 4]

// Apply a custom operation with a scalar
let powered = vector.broadcast(with: 2) { base, exponent in
    Int(pow(Double(base), Double(exponent)))
}  // [1, 4, 9, 16]

// Custom matrix-vector operations
let matrix = [[1, 2, 3], [4, 5, 6]]
let rowVector = [10, 100, 1000]

// Apply a custom operation between rows and a vector
let customRowOperation = matrix.broadcast(withRowVector: rowVector) { a, b in
    a * b + a  // a * (b + 1)
}
// [[11, 202, 3003], 
//  [44, 505, 6006]]
```

These custom operations provide maximum flexibility while still benefiting from the clean syntax of broadcasting.

### Use Cases

Broadcasting operations are particularly useful for:

- **Data normalization**: Subtract means or divide by standard deviations
- **Feature scaling**: Apply weights to feature vectors
- **Signal processing**: Apply filters or transformations to signals
- **Image processing**: Adjust color channels or apply transformations
- **Financial calculations**: Apply interest rates or time factors

### Implementation Details

Quiver implements broadcasting through extension methods on `Array` with appropriate type constraints:

- Scalar broadcasting is available for arrays with `Numeric` elements
- Division operations are only available for arrays with `FloatingPoint` elements
- Matrix-vector broadcasting requires collections of `Numeric` elements

The broadcasting implementations verify dimension compatibility at runtime, providing clear error messages when dimensions don't match.

## Topics

### Scalar Broadcasting
- ``Swift/Array/broadcast(adding:)``
- ``Swift/Array/broadcast(multiplyingBy:)``
- ``Swift/Array/broadcast(subtracting:)``
- ``Swift/Array/broadcast(dividingBy:)``

### Matrix-Vector Broadcasting
- ``Swift/Array/broadcast(addingToEachRow:)``
- ``Swift/Array/broadcast(addingToEachColumn:)``
- ``Swift/Array/broadcast(multiplyingEachRowBy:)``
- ``Swift/Array/broadcast(multiplyingEachColumnBy:)``

### Custom Broadcasting
- ``Swift/Array/broadcast(with:operation:)``
- ``Swift/Array/broadcast(withRowVector:operation:)``
- ``Swift/Array/broadcast(withColumnVector:operation:)``

### Related Articles
- <doc:Elements>
- <doc:Operations>
```
