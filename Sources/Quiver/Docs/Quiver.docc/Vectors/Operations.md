# Vector Operations

Transform arrays into mathematical vectors with magnitude, direction, and spatial relationships.

## Overview

Quiver provides a comprehensive set of vector operations that treat `arrays` as mathematical **vectors**, enabling calculations like `magnitude`, `normalization`, dot products, and angle measurements. 

> Tip: Vector operations are essential for graphics programming, physics simulations, machine learning algorithms, and any application that deals with spatial data or mathematical modeling. For a comprehensive introduction to vector mathematics, see [Vectors](https://waynewbishop.github.io/swift-algorithms/20-vectors.html) in Swift Algorithms & Data Structures.

### Basic vector properties

Quiver enables calculating fundamental vector properties. A `vector` is a mathematical object that represents both `magnitude` and direction. Unlike a scalar value, which represents only size (like temperature or weight), a `vector` captures directional information alongside its size:

```swift
import Quiver

let vector = [3.0, 4.0]

// Calculate the magnitude (length) of the vector
vector.magnitude  // 5.0

// Create a normalized version (unit vector)
vector.normalized  // [0.6, 0.8]

// See the rational form
vector.normalized.asFractions()  // [3/5, 4/5]
```

> Note: These vector properties are only available for arrays with elements that conform to `FloatingPoint` (like `Double` or `Float`).

> Important: Calling `normalized` on a zero vector returns a zero vector, and `cosineOfAngle(with:)` returns `0.0` if either vector has zero magnitude.

### Vector relationships

Calculate relationships between vectors with these operations:

```swift
let v1 = [3.0, 0.0]  // Vector along x-axis
let v2 = [0.0, 4.0]  // Vector along y-axis

// Calculate the dot product
v1.dot(v2)  // 0.0 (perpendicular vectors)

// Calculate the angle between vectors
v1.angle(with: v2)        // π/2 radians (90 degrees)
v1.angleInDegrees(with: v2)  // 90.0 degrees
```

> Tip: The dot product is zero when vectors are perpendicular and equals the product of their magnitudes when they're parallel.

### Vector averaging

Compute the element-wise average of two vectors:

```swift
let v1 = [2.0, 8.0]
let v2 = [6.0, 4.0]

// Average corresponding elements
let avg = [v1, v2].averaged()  // [4.0, 6.0]
```

### Vector projections

Projections help decompose vectors into components:

```swift
let v = [3.0, 4.0]
let axis = [1.0, 0.0]  // x-axis

// Calculate scalar projection (length of shadow)
v.scalarProjection(onto: axis)  // 3.0

// Calculate vector projection (component along axis)
v.vectorProjection(onto: axis)  // [3.0, 0.0]

// Calculate orthogonal component (perpendicular to axis)
v.orthogonalComponent(to: axis)  // [0.0, 4.0]
```

These operations are particularly useful in physics calculations, computer graphics, and geometric algorithms.

> Important: When projecting onto another vector, the target vector cannot be a zero vector (a vector with zero magnitude).

### Matrix-vector operations

Transform vectors using matrices:

```swift
let vector = [1.0, 2.0]
let matrix = [[0.0, -1.0], [1.0, 0.0]]  // 90° rotation matrix

// Apply matrix transformation (two equivalent ways)
let transformed = vector.transformedBy(matrix)  // [-2.0, 1.0]
let transformed2 = matrix.transform(vector)     // [-2.0, 1.0]
```

> Tip: Use `matrix.transform(vector)` to emphasize the matrix acting on the vector, matching mathematical notation Mv = w. Use `vector.transformedBy(matrix)` to emphasize the vector being transformed.

Matrix transformations are powerful tools for implementing rotations, scaling, and other geometric operations.

### Mathematical foundation

Vector operations in Quiver are based on well-established mathematical principles:

- **Magnitude**: √(x₁² + x₂² + ... + xₙ²)
- **Normalization**: v / ||v||
- **Dot product**: v₁·v₂ = v₁₁×v₂₁ + v₁₂×v₂₂ + ... + v₁ₙ×v₂ₙ
- **Cosine similarity**: cos(θ) = (v₁·v₂) / (||v₁|| × ||v₂||)
- **Vector projection**: proj_u(v) = (v·u / u·u) × u

> Note: Quiver follows standard mathematical conventions for vector operations, making it easier to translate mathematical formulas directly into code.

### Implementation details

Vector operations in Quiver are implemented as extensions to the `Array` type with appropriate type constraints:

- Basic properties like `magnitude` and `normalized` are available when elements conform to `FloatingPoint`
- Dot product is available when elements conform to `Numeric`
- Angle calculations use the mathematical relationship between dot product and vector magnitudes

This approach means these operations work directly on standard Swift arrays without conversion to special types.

## Topics

### Vector properties
- ``Swift/Array/magnitude``
- ``Swift/Array/normalized``

### Vector Relationships 
- ``Swift/Array/dot(_:)``
- ``Swift/Array/angle(with:)-piry``
- ``Swift/Array/angleInDegrees(with:)-7n2tx``
- ``Swift/Array/cosineOfAngle(with:)``
- ``Swift/Array/averaged()``

### Vector projections
- ``Swift/Array/scalarProjection(onto:)``
- ``Swift/Array/vectorProjection(onto:)``
- ``Swift/Array/orthogonalComponent(to:)``

### Matrix operations
- ``Swift/Array/transformedBy(_:)``

### Related articles
- <doc:Primer>
- <doc:Similarity-Operations>
- <doc:Transformation-Basics>
- <doc:Matrices-Operations>
- <doc:Broadcast>
