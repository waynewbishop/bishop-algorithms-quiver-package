# Quiver: Swift Vector Operations Framework
Quiver is a Swift package that provides powerful **vector operations** for Swift applications, inspired by NumPy's functionality in Python. This lightweight, functional and educational framework enables developers to perform element-wise operations, vector calculations, and matrix transformations with simple, readable syntax.

## Features
* Element-wise arithmetic operations (+, -, *, /)
* Vector calculations (dot product, magnitude, normalization)
* Angle calculations between vectors
* Projection operations
* Matrix-vector transformations
* Shape and dimension information

## Usage Examples
Quiver extends Swift's native Array type, providing seamless integration with your existing code.

```
import Quiver

// Basic vector operations
let v1 = [1.0, 2.0, 3.0]
let v2 = [4.0, 5.0, 6.0]

// Element-wise operations
let sum = v1 + v2                  // [5.0, 7.0, 9.0]
let product = v1 * v2              // [4.0, 10.0, 18.0]

// Mathematical vector operations
let dotProduct = v1.dot(v2)        // 32.0
let magnitude = v1.magnitude       // 3.74 (√14)

// Geometry operations
let angle = v1.angleInDegrees(with: v2)  // 14.42°
```

## Additional Benefits

### Enhanced Swift Charts Visualization
Quiver seamlessly integrates with Swift Charts to create powerful data visualizations:
* **Line Charts**: Use vector operations to transform and normalize data points
* **Scatter Plots**: Calculate distances, clusters, and projections for more meaningful plots
* **Bar Charts**: Apply scaling and normalization to raw data for better visualization

### Bridge to Python Data Science
Quiver adopts conventions similar to NumPy, making it easier to:
* Prepare data in Swift applications before sending to Python libraries
* Maintain consistency between Swift and Python codebases
* Simplify the learning curve when transitioning between languages
* Process data locally before sending to external services

## Audience
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
Have a question? Feel free to contact me on [LinkedIn](https://www.linkedin.com/in/waynebishop).
