# Element-wise Operations

Perform mathematical calculations on arrays and matrices where each element is processed independently.

## Overview

Quiver extends Swift's `Array` type to support element-wise arithmetic operations for:
- **Vectors** (1D arrays): element-wise and scalar operations
- **Matrices** (2D arrays): element-wise and scalar operations

This enables clean, NumPy-style syntax for numerical computing in Swift without requiring special vector or matrix classes. These operations form the foundation for Chapter 20 (Vectors) and Chapter 21 (Matrices) concepts in algorithms and data structures.

### Vector Arithmetic

Element-wise operations between two vectors:

```swift
let a = [1.0, 2.0, 3.0]
let b = [4.0, 5.0, 6.0]
let sum = a + b  // [5.0, 7.0, 9.0]
let difference = a - b  // [-3.0, -3.0, -3.0]
let product = a * b  // [4.0, 10.0, 18.0]
let quotient = a / b  // [0.25, 0.4, 0.5]
```

Scalar broadcasting with vectors:

```swift
let vector = [1.0, 2.0, 3.0]
let scaled = vector * 2.0     // [2.0, 4.0, 6.0]
let offset = vector + 10.0    // [11.0, 12.0, 13.0]
let divided = vector / 3.0    // [0.33..., 0.66..., 1.0]

// Commutative operations work both ways
let result1 = 2.0 * vector    // [2.0, 4.0, 6.0]
let result2 = 10.0 + vector   // [11.0, 12.0, 13.0]
```

### Matrix Arithmetic

Element-wise operations between two matrices:

```swift
let m1 = [[1.0, 2.0], [3.0, 4.0]]
let m2 = [[5.0, 6.0], [7.0, 8.0]]
let sum = m1 + m2  // [[6.0, 8.0], [10.0, 12.0]]
let difference = m1 - m2  // [[-4.0, -4.0], [-4.0, -4.0]]
let product = m1 * m2  // [[5.0, 12.0], [21.0, 32.0]] (Hadamard product)
let quotient = m1 / m2  // [[0.2, 0.33...], [0.42..., 0.5]]
```

Scalar broadcasting with matrices:

```swift
let matrix = [[100.0, 200.0], [300.0, 400.0]]

// Data standardization (z-score normalization)
let standardized = (matrix - 250.0) / 150.0

// Scaling
let scaled = matrix * 0.5

// Offset
let adjusted = matrix + 10.0

// Commutative operations work both ways
let doubled = 2.0 * matrix  // Same as matrix * 2.0
```

### How It Works

Quiver implements these operations by extending Swift's `Array` type:

**For vectors (1D arrays):**
- `Array where Element: Numeric` for +, -, *
- `Array where Element: FloatingPoint` for /

**For matrices (2D arrays):**
- `Array where Element == [Double]` for all operations
- `Array where Element == [Float]` for all operations

This design maintains Swift's type safety while providing concise syntax for numerical operations. Matrix operations leverage vector operations through composition—a matrix operation applies the corresponding vector operation to each row.

### Real-World Use Cases

**Data standardization (z-score):**
```swift
let features = [[100.0, 200.0], [300.0, 400.0]]
let mean = 250.0
let stdDev = 150.0
let standardized = (features - mean) / stdDev
```

**Sensor data combination:**
```swift
let sensor1 = [[1.0, 2.0], [3.0, 4.0]]
let sensor2 = [[0.5, 0.3], [0.7, 0.2]]
let combined = sensor1 + sensor2
```

**Feature scaling:**
```swift
let data = [[2.0, 4.0], [6.0, 8.0]]
let scaled = data * 0.5  // [[1.0, 2.0], [3.0, 4.0]]
```

### Preconditions

- **Vector-to-vector**: Arrays must have same length
- **Matrix-to-matrix**: Matrices must have same dimensions (rows × columns)
- **Division operations**: Divisor cannot contain zero elements
- **Scalar broadcasting**: Works with any dimensions

### NumPy Compatibility

These operations match NumPy's behavior for element-wise arithmetic and scalar broadcasting, making Quiver familiar to data science practitioners transitioning from Python to Swift.

**Important:** The `*` operator performs element-wise multiplication (Hadamard product), not matrix multiplication. For matrix multiplication (dot product), use `.multiplyMatrix()`.

### Integration with Swift's Standard Library

A key design principle of Quiver is seamless integration with Swift's standard library. These element-wise operations work directly on Swift's `Array` type—no need to convert to special vector or matrix classes.

This approach offers several advantages:
- No conversion overhead between data types
- Compatible with existing Swift code that works with arrays
- Familiar Swift syntax and behavior
- Full support for Swift's type system and generics

## See Also

- <doc:Operations>
- <doc:Fundamentals>
