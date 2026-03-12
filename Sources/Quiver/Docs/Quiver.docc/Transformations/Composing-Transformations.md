# Composing Transformations

Combine multiple transformations using matrix multiplication to create complex effects.

## Overview

Individual transformations like rotation and scaling are useful, but real applications often require combining them. Matrix multiplication lets us compose multiple transformations into a single operation, creating complex effects efficiently.

Understanding transformation composition is crucial for graphics pipelines, animation systems, and any application that chains coordinate system changes.

> Tip: For geometric intuition about how transformations compose, including visual examples of rotation, scaling, and chained operations, see [Matrix Transformations](https://waynewbishop.github.io/swift-algorithms/22-matrix-transformations.html) in Swift Algorithms & Data Structures.

## Matrix multiplication

Matrix multiplication composes transformations: the result represents applying one transformation after another. Unlike regular multiplication, **order matters**.

```swift
import Quiver

// 45° counterclockwise rotation and scaling matrices
let rotation = [
    [0.707, -0.707],
    [0.707,  0.707]
]
let scaling = [Double].diag([2.0, 2.0])

// Multiply matrices to compose transformations
let combined = rotation.multiplyMatrix(scaling)

// Apply to vector
let v = [1.0, 0.0]
let result = v.transformedBy(combined)
```

### Two equivalent approaches

**Approach 1: Compose first, apply once**
```swift
let combined = transform1.multiplyMatrix(transform2)
let result = vector.transformedBy(combined)
```

**Approach 2: Apply sequentially**
```swift
let result = vector
    .transformedBy(transform1)
    .transformedBy(transform2)
```

Both produce the same result, but composition is more efficient when applying the same transformation to many vectors.

## Order matters

Matrix multiplication is **not commutative**: `A × B ≠ B × A` in general.

```swift
import Foundation

// 90° counterclockwise rotation and scaling matrices
let rotate90 = [
    [0.0, -1.0],
    [1.0,  0.0]
]
let scale2x = [Double].diag([2.0, 1.0])

let v = [1.0, 0.0]

// Rotate then scale
let rotateFirst = v.transformedBy(rotate90).transformedBy(scale2x)
// [1,0] → rotate → [0,1] → scale → [0,1]

// Scale then rotate
let scaleFirst = v.transformedBy(scale2x).transformedBy(rotate90)
// [1,0] → scale → [2,0] → rotate → [0,2]

// Different results!
rotateFirst // [0, 1]
scaleFirst  // [0, 2]
```

### Reading order

When composing with matrix multiplication:

```swift
let combined = A.multiplyMatrix(B)
```

Means: "First apply **B**, then apply **A**"

```swift
// Rotate then scale
let combined = scale.multiplyMatrix(rotate)
v.transformedBy(combined)
// Same as: v.transformedBy(rotate).transformedBy(scale)
```

**Why?** Matrix multiplication applies from right to left:
- `v.transformedBy(A.multiplyMatrix(B))`
- = `(A × B) × v`
- = `A × (B × v)`  ← B applied first

## Common composition patterns

### Scale then rotate

```swift
// Make sprite 2× larger, then rotate 45°
let scale = [Double].diag([2.0, 2.0])

// 45° counterclockwise rotation
let rotate = [
    [0.707, -0.707],
    [0.707,  0.707]
]

// Compose: scale first, then rotate
let scaleRotate = rotate.multiplyMatrix(scale)
```

**Why this order?**
- Scaling along axes is simple when aligned with x/y
- Rotation changes orientation, making subsequent scaling more complex
- Generally: scale/shear first, rotate last

### Rotate around a point

To rotate around a point other than origin:
1. Translate point to origin
2. Rotate
3. Translate back

```swift
// Rotate around pivot point using a 3-step sequence
let pivot = [5.0, 5.0]
let vector = [6.0, 5.0]

// 90° rotation: [[0, -1], [1, 0]]
let rotate90 = [
    [0.0, -1.0],
    [1.0,  0.0]
]

// 1. Shift to origin, 2. Rotate, 3. Shift back
let rotated = (vector - pivot)
    .transformedBy(rotate90)
    + pivot
// (vector - pivot) = [1, 0]
// Row 1: [0, -1] • [1, 0] = (0×1 + (-1)×0) = 0
// Row 2: [1,  0] • [1, 0] = (1×1 +   0×0)  = 1
// Rotated: [0, 1] + [5, 5] = [5.0, 6.0]
```

### Multiple rotations

```swift
// Rotate 45° twice = 90° total
let rotate45 = [
    [0.707, -0.707],
    [0.707,  0.707]
]

// Compose two 45° rotations
let rotate90 = rotate45.multiplyMatrix(rotate45)

// Verify
[1.0, 0.0].transformedBy(rotate90)
// ≈ [0, 1] (within floating-point precision)
```

### Combining different transformations

```swift
// Complex transformation: scale, shear, then rotate
let scale = [Double].diag([2.0, 1.5])

// Horizontal shear with factor 0.3
let shear = [
    [1.0, 0.3],
    [0.0, 1.0]
]

// 90° counterclockwise rotation
let rotate = [
    [0.0, -1.0],
    [1.0,  0.0]
]

// Compose (remember: rightmost applied first)
let complex = rotate.multiplyMatrix(shear).multiplyMatrix(scale)

// Apply to many vectors efficiently
let vectors = [[1.0, 0.0], [0.0, 1.0], [1.0, 1.0]]
let transformed = vectors.map { $0.transformedBy(complex) }
```

## Transformation pipelines

Graphics applications often have transformation pipelines:

```swift
// Object → World → Camera → Screen
let objectToWorld = objectTransform
let worldToCamera = cameraTransform
let cameraToScreen = projectionTransform

// Compose entire pipeline
let objectToScreen = cameraToScreen
    .multiplyMatrix(worldToCamera)
    .multiplyMatrix(objectToWorld)

// Transform all vertices once
let screenVertices = objectVertices.map { $0.transformedBy(objectToScreen) }
```

### Incremental updates

When only one transform changes:

```swift
// Cache partial compositions
let worldToScreen = cameraToScreen.multiplyMatrix(worldToCamera)

// When object moves, only update final step
let newObjectToScreen = worldToScreen.multiplyMatrix(newObjectTransform)
```

## Inverse transformations

Some transformations can be reversed:

**Rotation inverse:**
```swift
// Rotate 90°, then rotate -90° returns to original
let rotate = [
    [0.0, -1.0],
    [1.0,  0.0]
]

// -90° rotation (clockwise)
let unrotate = [
    [ 0.0, 1.0],
    [-1.0, 0.0]
]

let identity = rotate.multiplyMatrix(unrotate)
// ≈ [[1,0],[0,1]] (within floating-point precision)
```

**Scaling inverse:**
```swift
// Scale by 2, then scale by 1/2 returns to original
let scale = [Double].diag([2.0, 2.0])
let unscale = [Double].diag([0.5, 0.5])

let identity = scale.multiplyMatrix(unscale)
// [[1,0],[0,1]]
```

## Performance optimization

### Precompute complex transformations

```swift
// BAD: Recompute for every vertex
for vertex in vertices {
    let transformed = vertex
        .transformedBy(scale)
        .transformedBy(rotate)
        .transformedBy(shear)
}

// GOOD: Compose once, apply many times
let combined = shear.multiplyMatrix(rotate).multiplyMatrix(scale)
for vertex in vertices {
    let transformed = vertex.transformedBy(combined)
}
```

### Matrix multiplication complexity

- Matrix multiplication: O(n³) for n×n matrices
- Matrix-vector multiplication: O(n²)

For n=2 (2D):
- Matrix × matrix: 8 multiplications, 4 additions
- Matrix × vector: 4 multiplications, 2 additions

**Implication:** For many vectors, compose first:
```swift
// Transform 1000 vertices
let vertices: [[Double]] = // 1000 2D points

// Inefficient: 1000 × (2 matrix-vector) = 12,000 operations
let result1 = vertices.map { $0.transformedBy(A).transformedBy(B) }

// Efficient: 1 matrix-matrix + 1000 matrix-vector = 6,012 operations
let AB = A.multiplyMatrix(B)
let result2 = vertices.map { $0.transformedBy(AB) }
```

## See also

- <doc:Transformation-Basics>
- <doc:Transformation-Common>
- <doc:Vector-Operations>

## Topics

### Transformation operations
- ``Swift/Array/transformedBy(_:)``

### Matrix creation
- ``Swift/Array/identity(_:)``
- ``Swift/Array/diag(_:)``
