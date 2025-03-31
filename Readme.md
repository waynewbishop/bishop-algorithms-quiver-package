# Quiver: Swift Vector Operations Framework
Quiver is a Swift package that provides powerful vector operations for Swift applications, inspired by NumPy's functionality in Python. This lightweight, educational framework enables developers to perform element-wise operations, vector calculations, and matrix transformations with simple, readable syntax.

## Features
* Element-wise arithmetic operations (+, -, *, /)
* Vector calculations (dot product, magnitude, normalization)
* Angle calculations between vectors
* Projection operations
* Matrix-vector transformations
* Shape and dimension information

## Usage Examples
Quiver extends Swift's native `Array` type, providing seamless integration with your existing code. If you're familiar with working with Arrays in Swift, you'll feel right at home with Quiver.

### Element-wise Operations
Perform arithmetic operations on vectors just like you would with scalars:

```
import Quiver

// Create arrays
let v1 = [2.0, 4.0, 6.0]
let v2 = [4.0, 8.0, 12.0]

// Element-wise addition
let sum = v1 + v2  // [6.0, 12.0, 18.0]

// Element-wise subtraction
let difference = v2 - v1  // [2.0, 4.0, 6.0]
```

### Vector Operations
Calculate dot products, magnitudes, and normalize vectors:

```
// Dot product
let dotProduct = v1.dot(v2)  // 112.0

// Magnitude (length) of vector
let magnitude = v1.magnitude  // 8.0

// Normalize vector to unit length
let unitVector = [1.0, 2.0, 2.0].normalized  // [0.33, 0.67, 0.67]
```

### Angle Calculations
Find the angle between two vectors:

```
let a = [3.0, 4.0]
let b = [5.0, 0.0]

// Vector projection
let projected = a.vectorProjection(onto: b)  // [3.0, 0.0]

// Scalar projection
let scalarProjection = a.scalarProjection(onto: b)  // 3.0
```

## Benefits Beyond Vector Operations

### Bridge to Python Data Science
Quiver adopts conventions similar to NumPy, making it easier to:
* Prepare data in Swift applications before sending to Python libraries
* Maintain consistency between Swift and Python codebases
* Simplify the learning curve when transitioning between languages
* Process data locally before sending to external services

### Enhanced Swift Charts Visualization
Quiver seamlessly integrates with Swift Charts to create powerful data visualizations:
* **Line Charts**: Use vector operations to transform and normalize data points
* **Scatter Plots**: Calculate distances, clusters, and projections for more meaningful plots
* **Bar Charts**: Apply scaling and normalization to raw data for better visualization

### Audience
Quiver is designed for:
* iOS/macOS developers working with numerical data
* Data scientists exploring Swift as an alternative to Python
* Educational settings teaching vector mathematics
* Developers building data visualization applications

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
Quiver is available under the Apache License, Version 2.0. See the LICENSE file for more info.

## Questions
Have a question? Feel free to contact me on ~[LinkedIn](https://www.linkedin.com/in/waynebishop)~.
