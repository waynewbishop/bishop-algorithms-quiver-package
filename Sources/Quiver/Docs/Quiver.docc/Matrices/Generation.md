# Array Generation

Create arrays with specific patterns and values for numerical computing tasks.

## Overview

Quiver provides a set of static methods to generate arrays with specific values, sequences, and patterns. These generation functions help you create arrays filled with zeros, ones, or custom values, as well as evenly spaced sequences or identity matrices.

### Basic array creation

Create arrays filled with specific values:

```swift
// Create 1D arrays
let zeros = [Double].zeros(5)        // [0.0, 0.0, 0.0, 0.0, 0.0]
let ones = [Int].ones(3)             // [1, 1, 1]
let filled = [Double].full(4, value: 3.14)  // [3.14, 3.14, 3.14, 3.14]
```

> Tip: Specify the element type by using the appropriate array type bracket notation like `[Double]` or `[Int]`.

### Creating sequences

Generate arrays with evenly spaced values:

```swift
// Create evenly spaced values
let linear = [Double].linspace(0, 10, num: 5)  // [0.0, 2.5, 5.0, 7.5, 10.0]

// Create sequences with specific step sizes
let range = [Double].arange(0, 10, step: 2.5)  // [0.0, 2.5, 5.0, 7.5]
```

> Note: The `linspace` function includes both endpoints, while `arange` includes the start value but excludes the end value, similar to Python's NumPy.

### Creating matrices

Generate 2D arrays (matrices) with specific patterns:

```swift
// Create 2D arrays
let zeroMatrix = [Int].zeros(3, 2)  
// [[0, 0], [0, 0], [0, 0]]

let oneMatrix = [Double].ones(2, 3)  
// [[1.0, 1.0, 1.0], [1.0, 1.0, 1.0]]

let filledMatrix = [Int].full(2, 2, value: 7)  
// [[7, 7], [7, 7]]
```

> Important: In Quiver, the first dimension represents rows and the second dimension represents columns, following mathematical convention.

### Special matrices

Create special-purpose matrices:

```swift
// Create an identity matrix
let identity = [Double].identity(3)  
// [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]

// Create a diagonal matrix from a vector
let diag = [Int].diag([1, 2, 3])  
// [[1, 0, 0], [0, 2, 0], [0, 0, 3]]
```

Identity and diagonal matrices are commonly used in linear algebra operations and transformations.

## Common patterns

These generation functions enable several common patterns in numerical computing:

### Initializing data structures

```swift
// Initialize a container for results
let results = [Double].zeros(dataPoints.count)

// Start with all ones (multiplicative identity)
let factors = [Double].ones(n)
```

### Creating test data

```swift
// Generate x-coordinates for plotting
let x = [Double].linspace(0, 2 * Double.pi, num: 100)

// Generate y-coordinates (sine wave)
let y = x.map { sin($0) }
```

### Setting up matrix operations

```swift
// Start with an identity matrix for transformations
var transform = [Double].identity(4)

// Modify specific elements for a particular transformation
transform[0][3] = 10.0  // Add translation
```

## Implementation details

The array generation functions in Quiver are implemented as static methods on Array extensions with appropriate type constraints. For example, sequence generation functions like `linspace` are only available on floating-point arrays, while basic creation functions like `zeros` are available for any numeric type.

> Warning: When creating large arrays, be mindful of memory usage. These functions allocate memory for the entire array at once.

## Topics

### Basic array creation
- ``Swift/Array/zeros(_:)``
- ``Swift/Array/ones(_:)``
- ``Swift/Array/full(_:value:)``

### Sequence generation
- ``Swift/Array/linspace(_:_:num:)``
- ``Swift/Array/arange(_:_:step:)-8fjm5``

### Matrix creation
- ``Swift/Array/zeros(_:_:)``
- ``Swift/Array/ones(_:_:)``
- ``Swift/Array/full(_:_:value:)``
- ``Swift/Array/identity(_:)``
- ``Swift/Array/diag(_:)``

### Related articles
- <doc:Matrices-Operations>
- <doc:Fundamentals>
