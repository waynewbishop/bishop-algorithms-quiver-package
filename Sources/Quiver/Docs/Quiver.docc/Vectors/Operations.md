# Vector Operations

Transform arrays into mathematical vectors with magnitude, direction, and spatial relationships.

## Overview

Quiver provides a comprehensive set of vector operations that treat `arrays` as mathematical **vectors**, enabling calculations like `magnitude`, `normalization`, dot products, and angle measurements. 

> Tip: Vector operations are essential for graphics programming, physics simulations, machine learning algorithms, and any application that deals with spatial data or mathematical modeling. For a comprehensive introduction to vector mathematics with step-by-step examples, see [Vectors](https://waynewbishop.github.io/swift-algorithms/20-vectors.html) in Swift Algorithms & Data Structures.

### Basic vector properties

Quiver enables you to calculate fundamental vector properties. A `vector` is a mathematical object that represents both `magnitude` and direction. Unlike a scalar value, which represents only size (like temperature or weight), a `vector` captures directional information alongside its size:

```swift
let vector = [3.0, 4.0]

// Calculate the magnitude (length) of the vector
vector.magnitude  // 5.0

// Create a normalized version (unit vector)
vector.normalized  // [0.6, 0.8]
```

> Note: These vector properties are only available for arrays with elements that conform to `FloatingPoint` (like `Double` or `Float`).

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

> Tip: Use `matrix.transform(vector)` when you want to emphasize the matrix acting on the vector, matching mathematical notation Mv = w. Use `vector.transformedBy(matrix)` when you want to emphasize the vector being transformed.

Matrix transformations are powerful tools for implementing rotations, scaling, and other geometric operations.

### Matrix arithmetic

Quiver supports element-wise arithmetic operations on 2D arrays (matrices):

```swift
let m1 = [[1.0, 2.0], [3.0, 4.0]]
let m2 = [[5.0, 6.0], [7.0, 8.0]]

// Element-wise operations
let sum = m1 + m2        // Addition: [[6.0, 8.0], [10.0, 12.0]]
let diff = m1 - m2       // Subtraction: [[-4.0, -4.0], [-4.0, -4.0]]
let product = m1 * m2    // Hadamard product (element-wise): [[5.0, 12.0], [21.0, 32.0]]
let quotient = m1 / m2   // Element-wise division: [[0.2, 0.33...], [0.42..., 0.5]]
```

> Important: The `*` operator performs element-wise multiplication (Hadamard product), not matrix multiplication. For matrix multiplication (dot product), use `.multiplyMatrix()`.

**Scalar broadcasting with matrices:**
```swift
let matrix = [[100.0, 200.0], [300.0, 400.0]]

// Data standardization (z-score)
let standardized = (matrix - 250.0) / 150.0

// Scaling and offset
let scaled = matrix * 0.5      // [[50.0, 100.0], [150.0, 200.0]]
let adjusted = matrix + 10.0   // [[110.0, 210.0], [310.0, 410.0]]
```

Matrix operations maintain the same preconditions as vector operations: dimensions must match for element-wise operations between matrices.

### Mathematical foundation

Vector operations in Quiver are based on well-established mathematical principles:

- **Magnitude**: √(x₁² + x₂² + ... + xₙ²)
- **Normalization**: v / ||v||
- **Dot product**: v₁·v₂ = v₁₁×v₂₁ + v₁₂×v₂₂ + ... + v₁ₙ×v₂ₙ
- **Cosine similarity**: cos(θ) = (v₁·v₂) / (||v₁|| × ||v₂||)
- **Vector projection**: proj_u(v) = (v·u / u·u) × u

> Note: Quiver follows standard mathematical conventions for vector operations, making it easier to translate mathematical formulas directly into code.

#### Broadcasting: Simplifying Operations

Broadcasting allows operations between arrays of different shapes:

```swift
let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
let rowVector = [10.0, 20.0, 30.0]

// Add the row vector to each row in the matrix
let result = matrix.broadcast(addingToEachRow: rowVector)
// [[11.0, 22.0, 33.0], [14.0, 25.0, 36.0]]
```
> Tip: Broadcasting eliminates the need for explicit loops when operating between arrays of compatible shapes.

### Implementation details

Vector operations in Quiver are implemented as extensions to the `Array` type with appropriate type constraints:

- Basic properties like `magnitude` and `normalized` are available when elements conform to `FloatingPoint`
- Dot product is available when elements conform to `Numeric`
- Angle calculations use the mathematical relationship between dot product and vector magnitudes

This approach means you can use these operations directly on standard Swift arrays without conversion to special types.

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
- <doc:Fundamentals>
