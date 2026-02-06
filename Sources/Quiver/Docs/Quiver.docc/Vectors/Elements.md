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

## Boolean comparisons

Compare array elements against scalar values or other arrays to create boolean masks:

```swift
let temperatures = [15.0, 22.0, 35.0, 18.0, 28.0]

// Compare against threshold values
let isHot = temperatures.isGreaterThan(25.0)
// [false, false, true, false, true]

let isCool = temperatures.isLessThan(20.0)
// [true, false, false, true, false]

let isModerate = temperatures.isGreaterThanOrEqual(18.0)
// [false, true, true, true, true]
```

### Array-to-array comparisons

Compare two arrays element-by-element:

```swift
let actual = [92.0, 88.0, 95.0, 78.0]
let expected = [90.0, 90.0, 95.0, 85.0]

let matches = actual.isEqual(to: expected)
// [false, false, true, false]
```

## Boolean logic

Combine boolean arrays using logical operations:

```swift
let temperatures = [15.0, 22.0, 35.0, 18.0, 28.0]
let humidity = [60.0, 80.0, 45.0, 70.0, 65.0]

// Find comfortable conditions (20-30°C)
let tempOk = temperatures.isGreaterThanOrEqual(20.0)
    .and(temperatures.isLessThanOrEqual(30.0))
// [false, true, false, false, true]

// Find dry conditions (humidity < 70%)
let humidityOk = humidity.isLessThan(70.0)
// [true, false, true, false, true]

// Combine conditions with AND
let comfortable = tempOk.and(humidityOk)
// [false, false, false, false, true]

// Either condition met with OR
let acceptable = tempOk.or(humidityOk)
// [true, true, true, false, true]

// Invert condition with NOT
let uncomfortable = comfortable.not
// [true, true, true, true, false]
```

## Boolean masking

Filter array elements using boolean masks:

```swift
let scores = [85.0, 45.0, 92.0, 38.0, 76.0, 88.0]
let passing = scores.isGreaterThanOrEqual(50.0)

// Extract only passing scores
let passedScores = scores.masked(by: passing)
// [85.0, 92.0, 76.0, 88.0]

// Get indices of passing scores
let passedIndices = passing.trueIndices
// [0, 2, 4, 5]
```

### Conditional selection

Choose elements from two arrays based on a condition:

```swift
let scores = [85.0, 45.0, 92.0, 38.0, 76.0]
let passing = scores.isGreaterThanOrEqual(50.0)

// Replace failing scores with zero
let zeros = [Double](repeating: 0.0, count: scores.count)
let adjusted = scores.choose(where: passing, otherwise: zeros)
// [85.0, 0.0, 92.0, 0.0, 76.0]
```

## Common use cases

### Data quality filtering

Identify and handle outliers or invalid data:

```swift
let readings = [23.5, 24.1, 150.0, 23.8, 22.9, -10.0, 24.5]

// Find valid temperature readings (0-50°C range)
let valid = readings.isGreaterThanOrEqual(0.0)
    .and(readings.isLessThanOrEqual(50.0))

// Extract only valid readings
let cleanData = readings.masked(by: valid)
// [23.5, 24.1, 23.8, 22.9, 24.5]

// Count invalid readings
let invalidCount = valid.not.trueIndices.count  // 2
```

### Threshold-based classification

Classify data into categories based on threshold values:

```swift
let sales = [12500.0, 8200.0, 15800.0, 6100.0, 18200.0]

// Classify performance: high (>15k), medium (10-15k), low (<10k)
let isHigh = sales.isGreaterThan(15000.0)
let isMedium = sales.isGreaterThanOrEqual(10000.0)
    .and(sales.isLessThanOrEqual(15000.0))

let highPerformers = sales.masked(by: isHigh)
// [15800.0, 18200.0]

let mediumPerformers = sales.masked(by: isMedium)
// [12500.0]
```

### Multi-condition filtering

Filter data using complex logical conditions:

```swift
let ages = [22, 45, 17, 33, 19, 28, 55]
let hasLicense = [true, true, false, true, true, false, true]

// Find eligible drivers (age >= 18 AND has license)
let ageEligible = ages.isGreaterThanOrEqual(18)
let eligible = ageEligible.and(hasLicense)

let eligibleAges = ages.masked(by: eligible)
// [22, 45, 33, 19, 28, 55]

let eligibleCount = eligible.trueIndices.count  // 6
```

### Sensor data validation

Combine multiple sensor readings with validation:

```swift
let sensor1 = [[1.0, 2.0], [3.0, 4.0]]
let sensor2 = [[0.5, 0.3], [0.7, 0.2]]
let combined = sensor1 + sensor2
// [[1.5, 2.3], [3.7, 4.2]]
```

### Financial data aggregation

Aggregate data across time periods:

```swift
let sales2023 = [[100.0, 200.0], [300.0, 400.0]]
let sales2024 = [[150.0, 250.0], [350.0, 450.0]]
let totalSales = sales2023 + sales2024
// [[250.0, 450.0], [650.0, 850.0]]
```

### Preconditions

- **Vector-to-vector**: Arrays must have same length
- **Matrix-to-matrix**: Matrices must have same dimensions (rows × columns)
- **Division operations**: Divisor cannot contain zero elements

## Performance characteristics

Element-wise operations in Quiver are optimized for efficiency:

- **Complexity:** All element-wise operations are O(n) where n is the array length
- **Memory:** Operations create new arrays, preserving functional programming style
- **Chaining:** Multiple operations can be chained naturally using Swift's fluent syntax

**Example of chained operations:**
```swift
let data = [10.0, 25.0, 30.0, 15.0, 40.0]

// Chain multiple boolean operations
let result = data
    .isGreaterThan(20.0)          // [false, true, true, false, true]
    .and(data.isLessThan(35.0))   // [false, true, true, false, false]

let filtered = data.masked(by: result)  // [25.0, 30.0]
```

## Integration with Swift's Standard Library

A key design principle of Quiver is seamless integration with Swift's standard library. These element-wise operations work directly on Swift's `Array` type—no need to convert to special vector or matrix classes.

This approach offers several advantages:
- No conversion overhead between data types
- Compatible with existing Swift code that works with arrays
- Familiar Swift syntax and behavior
- Full support for Swift's type system and generics

**Important:** The `*` operator performs element-wise multiplication (Hadamard product), not matrix multiplication. For matrix multiplication (dot product), use `.multiplyMatrix()`.

## Topics

### Boolean comparisons
- ``Swift/Array/isEqual(to:)``
- ``Swift/Array/isGreaterThan(_:)``
- ``Swift/Array/isLessThan(_:)``
- ``Swift/Array/isGreaterThanOrEqual(_:)``
- ``Swift/Array/isLessThanOrEqual(_:)``

### Boolean logic
- ``Swift/Array/and(_:)``
- ``Swift/Array/or(_:)``
- ``Swift/Array/not``

### Masking and filtering
- ``Swift/Array/masked(by:)``
- ``Swift/Array/choose(where:otherwise:)``
- ``Swift/Array/trueIndices``

## See also

- <doc:Operations>
- <doc:Statistics>
- <doc:Fundamentals>
