# Random Number Generation

Generate arrays of random values for testing, simulation, and initialization.

## Overview

Quiver provides methods to generate arrays filled with random values between 0 and 1. These functions are essential for creating test data, running simulations, initializing weight matrices, and any application that requires random numbers in array form.

### Generating random arrays

Create arrays with uniformly distributed random values:

```swift
import Quiver

// Generate a 1D array of 5 random values between 0 and 1
let randomValues = [Double].random(5)
// Example output: [0.12, 0.87, 0.43, 0.59, 0.22]

// Generate a 2D array (3×2 matrix) of random values
let randomMatrix = [Double].random(3, 2)
// Example output:
// [[0.31, 0.95],
//  [0.47, 0.72],
//  [0.13, 0.84]]
```

> Note: Each call produces different random values. The examples above show possible outputs.

### Float and double support

Random generation works with both `Float` and `Double` types:

```swift
// Generate an array of random Float values
let randomFloats = [Float].random(3)
// Example: [0.23, 0.68, 0.91]

// Generate an array of random Double values
let randomDoubles = [Double].random(3)
// Example: [0.45, 0.27, 0.84]
```

### Scaling to custom ranges

Random values in the `[0, 1]` range can be scaled to any desired range through simple arithmetic:

```swift
// Random test scores between 0 and 100
let testScores = [Double].random(10).map { $0 * 100 }
// Example: [45.2, 87.3, 32.9, 76.1, 94.5, 21.8, 65.3, 50.9, 88.2, 12.7]

// Random temperatures between -10 and 40
let temperatures = [Double].random(7).map { -10.0 + $0 * 50.0 }
// Example: [12.5, -3.2, 28.7, 5.1, 35.8, -8.4, 19.3]
```

> Tip: The formula for scaling to range [min, max] is: `min + random * (max - min)`.

## Common use cases

### Monte Carlo simulation

Estimate the area of a circle using random sampling — a classic Monte Carlo technique:

```swift
// Generate random points in a unit square
let n = 10000
let xs = [Double].random(n)
let ys = [Double].random(n)

// Count points falling inside the unit circle (x² + y² ≤ 1)
var insideCircle = 0
for i in 0..<n {
    if xs[i] * xs[i] + ys[i] * ys[i] <= 1.0 {
        insideCircle += 1
    }
}

// Estimate π: ratio of circle area to square area × 4
let piEstimate = 4.0 * Double(insideCircle) / Double(n)
// Approximately 3.14
```

### Initializing weight matrices

Random initialization is common when setting up neural network layers or testing matrix operations:

```swift
// Initialize a 3×4 weight matrix with small random values
let weights = [Double].random(3, 4).map { row in
    row.map { $0 * 0.1 }  // Scale to [-0.05, 0.05] range
}

// Create a random bias vector
let bias = [Double].random(4).map { $0 * 0.01 }
```

### Simple simulation

Use random values for a basic coin flip simulation:

```swift
// Simulate 20 coin flips (values < 0.5 are tails, >= 0.5 are heads)
let coinFlips = [Double].random(20).map { $0 < 0.5 ? "Tails" : "Heads" }
// Example: ["Heads", "Tails", "Heads", "Heads", "Tails", ...]

// Count the number of heads
let headsCount = coinFlips.filter { $0 == "Heads" }.count
```

### Random selection

Randomly select items from an array:

```swift
let fruits = ["Apple", "Banana", "Cherry", "Date", "Fig"]

// Generate a safe random index within bounds
let randomValue = [Double].random(1)[0]
let randomIndex = min(Int(randomValue * Double(fruits.count)), fruits.count - 1)
let selectedFruit = fruits[randomIndex]
// Selects a random fruit from the array
```

### Generating test datasets

Create synthetic data for testing statistical operations:

```swift
// Generate a dataset with known characteristics
let baseline = [Double].random(100).map { $0 * 20.0 + 50.0 }
// Values between 50 and 70

// Compute statistics on the random data
let avg = baseline.mean()     // Approximately 60.0
let std = baseline.std()      // Approximately 5.8
```

### Implementation details

The random number generation in Quiver uses Swift's built-in random functions. These functions return high-quality random values uniformly distributed between 0 and 1. We can scale these values to any desired range by simple multiplication and addition.

## Topics

### Random array generation
- ``Swift/Array/random(_:)-6ulik``
- ``Swift/Array/random(_:_:)-9gsef``

### Related articles
- <doc:Statistics>
