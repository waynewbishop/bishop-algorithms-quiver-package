# Matrix Transformations

Apply transformations to vectors using matrices.

## Overview

Matrices transform vectors through multiplication. A transformation matrix modifies a vector's position, orientation, or scale in space. Common transformations include rotation, scaling, reflection, and shearing.

> Tip: For geometric intuition about how transformations work, including basis vectors, coordinate systems, and visual examples, see [Matrix Transformations](https://waynewbishop.github.io/swift-algorithms/22-transformations.html) in Swift Algorithms & Data Structures.

## Basic usage

Transform a vector by multiplying it with a transformation matrix:

```swift
import Quiver

// A 90° counterclockwise rotation matrix
let rotation = [
    [0.0, -1.0],
    [1.0,  0.0]
]

let vector = [1.0, 0.0]
let rotated = vector.transformedBy(rotation)
// [0.0, 1.0] - vector now points up
```

## Matrix-vector multiplication

Matrix-vector multiplication uses the **dot product** between each matrix row and the vector:

```swift
let matrix = [
    [2.0, 0.0],
    [0.0, 3.0]
]

let v = [4.0, 5.0]
let result = v.transformedBy(matrix)
// [8.0, 15.0]
```

**How it works:**
```
Row 1: [2, 0] • [4, 5] = (2×4 + 0×5) = 8
Row 2: [0, 3] • [4, 5] = (0×4 + 3×5) = 15
Result: [8, 15]
```

**Dimension requirement:** The matrix must have the same number of **columns** as the vector has **elements**.

**Quiver provides two equivalent syntaxes:**

```swift
// Vector perspective (recommended)
let transformed = vector.transformedBy(matrix)

// Matrix perspective
let transformed = matrix.transform(vector)
```

## Creating transformation matrices

### Identity matrix

The identity matrix leaves vectors unchanged:

```swift
let identity = [Double].identity(2)
// [[1.0, 0.0],
//  [0.0, 1.0]]

[3.0, 4.0].transformedBy(identity)  // [3.0, 4.0]
```

### Diagonal matrices (scaling)

Diagonal matrices scale each axis independently:

```swift
// Create diagonal matrix: values on diagonal, zeros elsewhere
let scale = [Double].diag([2.0, 3.0])
// [[2.0, 0.0],
//  [0.0, 3.0]]

[4.0, 5.0].transformedBy(scale)  // [8.0, 15.0]
```

## Common transformations

For detailed transformation examples (rotation, scaling, reflection, shearing), see <doc:Common>.

### Rotation example

```swift
import Foundation

func rotationMatrix(angle: Double) -> [[Double]] {
    let cos = cos(angle)
    let sin = sin(angle)
    return [
        [cos, -sin],
        [sin,  cos]
    ]
}

let rotate45 = rotationMatrix(angle: .pi / 4)
[1.0, 0.0].transformedBy(rotate45)  // [0.707, 0.707]
```

### Scaling example

```swift
// Uniform scaling
let scale2x = [Double].diag([2.0, 2.0])
[3.0, 4.0].transformedBy(scale2x)  // [6.0, 8.0]

// Non-uniform scaling
let stretch = [Double].diag([3.0, 0.5])
[2.0, 4.0].transformedBy(stretch)  // [6.0, 2.0]
```

## See also

- <doc:Common> - Rotation, scaling, reflection, shearing examples
- <doc:Composition> - Combining multiple transformations
- <doc:Matrices-Operations> - Matrix arithmetic and operations
- <doc:Operations> - Vector operations

## Topics

### Matrix creation
- ``Swift/Array/identity(_:)``
- ``Swift/Array/diag(_:)``

### Transformation operations
- ``Swift/Array/transformedBy(_:)``
