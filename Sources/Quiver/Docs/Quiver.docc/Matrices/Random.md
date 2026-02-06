# Random Number Generation

Generate arrays of random values for testing and simulation.

## Overview

Quiver provides methods to generate arrays filled with random values between 0 and 1. These functions are useful for creating test data, simulations, and any application that requires random numbers.

### Generating random arrays

Create arrays with uniformly distributed random values:

```swift
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

> Note: Each call produces different random values. The examples above just show possible outputs.

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

### Creating test data

Generate random data for testing:

```swift
// Create random test scores between 0 and 100
let testScores = [Double].random(10).map { $0 * 100 }
// Example: [45.2, 87.3, 32.9, 76.1, 94.5, 21.8, 65.3, 50.9, 88.2, 12.7]
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
let randomIndex = Int([Double].random(1)[0] * Double(fruits.count))
let selectedFruit = fruits[randomIndex]
// Might select any fruit from the array
```

### Implementation details

The random number generation in Quiver uses Swift's built-in random functions. These functions return high-quality random values uniformly distributed between 0 and 1. By default, the random values are generated in the range `[0, 1]` which you can scale to any desired range by simple multiplication.

> Tip: To generate random numbers in a specific range, multiply the values by the range size and add the minimum value. For example, for values between 5 and 10: `random(3).map { 5 + $0 * 5 }`

## Topics

### Random array generation
- ``Swift/Array/random(_:)-6ulik``  
- ``Swift/Array/random(_:_:)-9gsef``  

### Related articles
- <doc:Statistics>
