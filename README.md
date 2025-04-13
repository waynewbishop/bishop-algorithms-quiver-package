# Quiver: Swift Vector Mathematics and Numerical Computing

Quiver is a Swift package that provides powerful numerical computing capabilities for Swift applications. This lightweight, functional and educational framework extends Swift's native `Array` type with vector operations, statistical functions, and array manipulation tools.

## Features

* **Vector Operations**
  * Element-wise arithmetic operations (+, -, *, /)
  * Dot product, magnitude, normalization
  * Angle calculations and vector projections
  * Matrix-vector transformations

* **Statistical Functions**
  * Basic statistics (mean, median, min, max)
  * Variance and standard deviation
  * Cumulative operations (sum, product)

* **Array Generation and Manipulation**
  * Generate arrays (zeros, ones, linspace, random)
  * Create special matrices (identity, diagonal)
  * Shape information and transformation

* **Data Analysis Tools**
  * Boolean operations and filtering
  * Broadcasting operations
  * Comparison operations

## Simple Example

```swift
import Quiver

// Calculate the distance between two points in a game
let playerPosition = [42.5, 67.3]
let targetPosition = [56.2, 89.7]

// Vector subtraction and magnitude calculation
let displacement = targetPosition - playerPosition
let distance = displacement.magnitude  // 26.24

// Is the target within interaction range?
if distance < 30.0 {
    print("Target within range!")
}
```

## Design Philosophy

Quiver is built on several core principles:

* **Swift-first approach**: Extends native Swift arrays rather than creating custom types
* **No conversion overhead**: Work directly with Swift arrays without type conversion
* **Educational focus**: Clear implementations that map to mathematical concepts
* **Progressive disclosure**: Simple operations are simple, complex operations are possible

## Documentation

Comprehensive documentation is available including:
* Vector operation guides
* Statistical function references
* Linear algebra primer for beginners
* Swift Charts integration examples

## When to Use Quiver

Quiver is particularly useful for:

* **iOS/macOS developers** working with numerical data or spatial calculations
* **Game developers** implementing physics, collision detection, or pathfinding
* **Data visualization** projects using Swift Charts
* **Educational settings** teaching vector mathematics and numerical computing
* **Data analysis** tasks requiring statistical operations

## Swift Charts Integration

Quiver seamlessly integrates with Swift Charts for data visualization:
* Generate sequences for x-coordinates
* Calculate statistics for reference lines
* Normalize data for consistent scaling
* Filter data points based on conditions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Quiver is available under the Apache License, Version 2.0. See the LICENSE file for more info.

## Questions

Have a question? Feel free to contact me on [LinkedIn](https://www.linkedin.com/in/waynebishop).
