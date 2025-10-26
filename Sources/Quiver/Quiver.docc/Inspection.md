# Data Inspection

Examine the contents and statistics of your arrays.

## Overview

Quiver provides the `info()` method to inspect and understand your data during development and debugging. This inspection tool gives you a quick overview of your array's type, count, statistical properties (for numeric arrays), and a preview of the contents.

### The `info()` Method

The `info()` method provides a comprehensive overview of an array, including type details, statistical summaries (for floating-point arrays), and a preview of the data:

```swift
// For numeric vectors (1D arrays)
let vector = [3.5, 1.8, 4.2, 2.7, 5.1]
print(vector.info())
// Output:
// Array Information:
// Count: 5
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

// For integer arrays (without statistics)
let counts = [10, 20, 30, 40, 50]
print(counts.info())
// Output:
// Array Information:
// Count: 5
// Type: Int.Type
//
// First 5 items:
// [0]: 10
// [1]: 20
// [2]: 30
// [3]: 40
// [4]: 50
```

### Statistical Information

For arrays of floating-point numbers (`Double` or `Float`), the `info()` method automatically includes statistical summaries:

- **Mean**: The average value of all elements
- **Min**: The smallest value in the array
- **Max**: The largest value in the array

This makes it easy to quickly understand the distribution and range of your data without writing additional code.

```swift
let measurements = [23.5, 24.1, 23.8, 24.3, 23.9, 24.0]
print(measurements.info())
// Shows mean, min, max, and sample values
```

### When to Use `info()`

The `info()` method is particularly useful in these scenarios:

- **Debugging**: Quickly verify array contents and statistics during development
- **Data validation**: Check that loaded data has expected characteristics
- **Interactive exploration**: Understand dataset properties in playgrounds or REPL environments
- **Logging**: Generate informative output for debugging logs

### Workflow Integration

Integrating `info()` into your workflow improves productivity:

```swift
import Quiver

// Load or generate data
let sensorReadings = loadSensorData()

// Quick inspection during development
print("Sensor data overview:")
print(sensorReadings.info())

// The info() output helps you understand:
// - How many readings were collected (count)
// - What type of values they are (type)
// - Statistical distribution (mean, min, max)
// - Sample values to verify correct parsing
```

### Preview Limit

The `info()` method shows the first 5 items of your array. For longer arrays, this gives you a representative sample without overwhelming output:

```swift
let largeDataset = [Double].random(1000)
print(largeDataset.info())
// Shows statistics for all 1000 values
// But only displays first 5 items
```

## Implementation Details

The `info()` method is implemented as an overloaded function with different capabilities based on element type:

- **For numeric types** (`Int`, `Double`, etc.): Shows count, type, and preview
- **For floating-point types** (`Double`, `Float`): Adds mean, min, and max statistics

This progressive enhancement ensures you get the most relevant information for your data type.

## Topics

### Inspection Methods
- ``Swift/Array/info()-44fcx``

### Related Articles
- <doc:Statistics>
- <doc:Elements>
