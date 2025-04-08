# Comparison Operations

Compare array elements and create boolean masks for filtering and selection.

## Overview

Quiver provides comparison operations that let you compare arrays element-wise, create boolean masks, and use these masks to filter and select data. These operations are fundamental for data analysis and processing.

Comparison operations enable declarative, functional approaches to array manipulation without resorting to explicit loops or complex conditional logic.

### Element-wise Comparisons

Quiver lets you compare arrays with values to create boolean masks:

```swift
let values = [1, 5, 3, 7, 2, 8, 4, 6]

// Create boolean masks through comparisons
let greaterThan5 = values.isGreaterThan(5)  // [false, false, false, true, false, true, false, true]
let lessThanOrEqual3 = values.isLessThanOrEqual(3)  // [true, false, true, false, true, false, false, false]
```

You can also compare two arrays element-wise:

```swift
let a = [1, 2, 3, 4]
let b = [1, 3, 3, 5]

// Check element-wise equality
let equal = a.isEqual(to: b)  // [true, false, true, false]
```

> Note: When comparing two arrays, they must have the same length. Quiver will check this at runtime and trigger a precondition failure if the dimensions don't match.

### Boolean Operations

After creating boolean masks, you can combine them with logical operations:

```swift
let values = [1, 5, 3, 7, 2, 8, 4, 6]
let between3And7 = values.isGreaterThanOrEqual(3).and(values.isLessThanOrEqual(7))  
// [false, true, true, true, false, false, true, false]

let outsideRange = between3And7.not  
// [true, false, false, false, true, true, false, true]
```

> Tip: Boolean operations provide a powerful way to express complex conditions in a readable, declarative style.

### Filtering with Masks

Boolean masks can be used to filter arrays and extract elements that meet specific criteria:

```swift
let values = [1, 5, 3, 7, 2, 8, 4, 6]
let greaterThan5 = values.isGreaterThan(5)  // [false, false, false, true, false, true, false, true]

// Extract elements where the mask is true
let largeValues = values.masked(by: greaterThan5)  // [7, 8, 6]

// Find indices where the condition is true
let largeIndices = greaterThan5.trueIndices  // [3, 5, 7]
```

This approach is similar to NumPy's boolean indexing and provides a concise way to filter data.

### Conditional Selection

The `choose` method lets you select elements from one array or another based on a condition:

```swift
let values = [1, 5, 3, 7, 2, 8, 4, 6]
let isEven = values.map { $0 % 2 == 0 }  // [false, false, false, false, true, true, true, true]

// Replace odd values with zeros
let evenOrZero = values.choose(where: isEven, otherwise: [0, 0, 0, 0, 0, 0, 0, 0])  
// [0, 0, 0, 0, 2, 8, 4, 6]
```

> Important: The arrays passed to `choose` must all have the same length, including both the source array and the "otherwise" array.

### Use Cases

Boolean operations and masks are particularly useful for:

- **Data cleaning**: Identifying and filtering outliers or invalid data
- **Feature engineering**: Creating derived features based on conditions
- **Analysis**: Subsetting data for specific analysis tasks
- **Transformation**: Applying different operations to different elements based on conditions

### Implementation Details

Comparison operations in Quiver are implemented as extensions to the `Array` type with elements that conform to `Comparable`. Boolean operations are implemented as extensions to `Array` where the element type is `Bool`.

This approach provides a natural and intuitive API for working with comparisons and boolean operations.

## Topics

### Comparison Operations
- ``Swift/Array/isEqual(to:)``
- ``Swift/Array/isGreaterThan(_:)``
- ``Swift/Array/isLessThan(_:)``
- ``Swift/Array/isGreaterThanOrEqual(_:)``
- ``Swift/Array/isLessThanOrEqual(_:)``

### Boolean Operations
- ``Swift/Array/and(_:)``
- ``Swift/Array/or(_:)``
- ``Swift/Array/not``
- ``Swift/Array/trueIndices``

### Selection and Filtering
- ``Swift/Array/masked(by:)``
- ``Swift/Array/choose(where:otherwise:)``

### Related Articles
- <doc:Operations>
