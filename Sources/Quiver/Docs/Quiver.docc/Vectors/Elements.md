# Element-wise Operations

Perform mathematical calculations on arrays and matrices where each element is processed independently.

## Overview

Quiver extends Swift's `Array` type to support element-wise arithmetic operations between arrays of the same dimensions:
- **Vectors** (1D arrays): element-wise operations between two vectors
- **Matrices** (2D arrays): element-wise operations between two matrices

### Vector arithmetic

Element-wise operations between two vectors:

```swift
let a = [1.0, 2.0, 3.0]
let b = [4.0, 5.0, 6.0]
let sum = a + b  // [5.0, 7.0, 9.0]
let difference = a - b  // [-3.0, -3.0, -3.0]
let product = a * b  // [4.0, 10.0, 18.0]
let quotient = a / b  // [0.25, 0.4, 0.5]
```

### Matrix arithmetic

Element-wise operations between two matrices:

```swift
let m1 = [[1.0, 2.0], [3.0, 4.0]]
let m2 = [[5.0, 6.0], [7.0, 8.0]]
let sum = m1 + m2  // [[6.0, 8.0], [10.0, 12.0]]
let difference = m1 - m2  // [[-4.0, -4.0], [-4.0, -4.0]]
let product = m1 * m2  // [[5.0, 12.0], [21.0, 32.0]] (Hadamard product)
let quotient = m1 / m2  // [[0.2, 0.33...], [0.42..., 0.5]]
```

> Important: For scalar broadcasting (operations between arrays and single values) and advanced row/column broadcasting, see <doc:Broadcast>.

### Real-world use cases

**Sensor data combination:**
```swift
let sensor1 = [[1.0, 2.0], [3.0, 4.0]]
let sensor2 = [[0.5, 0.3], [0.7, 0.2]]
let combined = sensor1 + sensor2
```

**Data aggregation:**
```swift
let sales2023 = [[100.0, 200.0], [300.0, 400.0]]
let sales2024 = [[150.0, 250.0], [350.0, 450.0]]
let totalSales = sales2023 + sales2024
```

### Preconditions

- **Vector-to-vector**: Arrays must have same length
- **Matrix-to-matrix**: Matrices must have same dimensions (rows × columns)
- **Division operations**: Divisor cannot contain zero elements

### NumPy Compatibility

These operations match NumPy's behavior for element-wise arithmetic, making Quiver familiar to data science practitioners transitioning from Python to Swift.

**Important:** The `*` operator performs element-wise multiplication (Hadamard product), not matrix multiplication. For matrix multiplication (dot product), use `.multiplyMatrix()`.

### Integration with Swift's Standard Library

A key design principle of Quiver is seamless integration with Swift's standard library. These element-wise operations work directly on Swift's `Array` type—no need to convert to special vector or matrix classes.

This approach offers several advantages:
- No conversion overhead between data types
- Compatible with existing Swift code that works with arrays
- Familiar Swift syntax and behavior
- Full support for Swift's type system and generics

## See also

- <doc:Operations>
- <doc:Fundamentals>
