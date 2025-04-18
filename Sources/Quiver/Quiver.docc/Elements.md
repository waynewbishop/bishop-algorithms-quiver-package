# Element-wise Operations

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

Perform mathematical calculations on arrays where each element is processed independently.

## Overview

Quiver extends Swift's `Array` type to support element-wise arithmetic operations for numeric arrays. This means you can add, subtract, multiply, and divide arrays without writing loops or complex logic.
Element-wise operations are fundamental to numerical computing and allow you to express `Array` transformations clearly and concisely.

### Basic Arithmetic
Quiver adds support for the standard arithmetic operators (+, -, *, /) to work between arrays or between arrays and scalar values.

```swift
// Element-wise addition
let a = [1, 2, 3]
let b = [4, 5, 6]
let sum = a + b  // [5, 7, 9]

// Element-wise subtraction
let difference = a - b  // [-3, -3, -3]

// Element-wise multiplication
let product = a * b  // [4, 10, 18]

// Element-wise division (for floating-point arrays)
let x = [4.0, 6.0, 8.0]
let y = [2.0, 3.0, 4.0]
let quotient = x / y  // [2.0, 2.0, 2.0]
```

### How It Works
Quiver implements these operations by extending Swift's `Array` type where the elements conform to the **Numeric** protocol. This means the operations work on arrays of `Int`, `Double`, `Float`, and other numeric types.
For example, the addition operator is implemented like this:

```swift
public extension Array where Element: Numeric {
    /// Element-wise addition of two vectors
    static func + (lhs: [Element], rhs: [Element]) -> [Element] {
        // The implementation checks dimensions and performs the operation
        let v1 = _Vector(elements: lhs)
        let v2 = _Vector(elements: rhs)
        return _Vector.add(v1, v2).elements
    }
}
```

These operations maintain Swift's type safety while providing a concise syntax for numerical operations.

### Preconditions

When using element-wise operations, the arrays must have the same dimensions. If you try to operate on arrays of different lengths, Quiver will trigger a precondition failure with an informative error message.

Division operations are only available for arrays with floating-point elements (`Double`, `Float`), as division on integer types can lead to loss of precision.

### Information and Inspection

Quiver provides a convenient way to inspect arrays with the `info()` method:

```swift
let values = [1.0, 2.5, 3.7, 4.2, 5.0]
print(values.info())
// Output:
// Array Information:
// Count: 5
// Shape: (5, 0)
// Type: Double.Type
// Mean: 3.28
// Min: 1.0
// Max: 5.0
//
// First 5 items:
// [0]: 1.0
// [1]: 2.5
// [2]: 3.7
// [3]: 4.2
// [4]: 5.0
```

### Integration with Swift's Standard Library

A key design principle of Quiver is seamless integration with Swift's standard library. These element-wise operations work directly on Swift's `Array` type - there's no need to convert to a special vector or matrix class first.

This approach offers several advantages:
- No conversion overhead between data types
- Compatible with existing Swift code that works with arrays
- Familiar Swift syntax and behavior
- Full support for Swift's type system and generics

## Topics

### Basic Operations

- ``Swift/Array/+(_:_:)``
- ``Swift/Array/-(_:_:)``
- ``Swift/Array/*(_:_:)``
- ``Swift/Array//(_:_:)``

### Related Articles

- <doc:Statistics>
