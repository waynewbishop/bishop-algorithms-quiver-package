# Vector Operations

Transform arrays into mathematical vectors with magnitude, direction, and spatial relationships.

## Overview

Quiver provides a comprehensive set of vector operations that treat arrays as mathematical vectors, enabling calculations like magnitude, normalization, dot products, and angle measurements.

These operations are essential for graphics programming, physics simulations, machine learning algorithms, and any application that deals with spatial data or mathematical modeling.

### Basic Vector Properties

Quiver enables you to calculate fundamental vector properties:

```swift
let vector = [3.0, 4.0]

// Calculate the magnitude (length) of the vector
vector.magnitude  // 5.0

// Create a normalized version (unit vector)
vector.normalized  // [0.6, 0.8]
```

> Note: These vector properties are only available for arrays with elements that conform to `FloatingPoint` (like `Double` or `Float`).

### Vector Relationships

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

### Vector Projections

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

### Matrix-Vector Operations

Transform vectors using matrices:

```swift
let vector = [1.0, 2.0]
let matrix = [[0.0, -1.0], [1.0, 0.0]]  // 90° rotation matrix

// Apply matrix transformation
let transformed = vector.transformedBy(matrix)  // [-2.0, 1.0]
```

Matrix transformations are powerful tools for implementing rotations, scaling, and other geometric operations.

### Mathematical Foundation

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

### Implementation Details

Vector operations in Quiver are implemented as extensions to the `Array` type with appropriate type constraints:

- Basic properties like `magnitude` and `normalized` are available when elements conform to `FloatingPoint`
- Dot product is available when elements conform to `Numeric`
- Angle calculations use the mathematical relationship between dot product and vector magnitudes

This approach means you can use these operations directly on standard Swift arrays without conversion to special types.

## Topics

### Vector Properties
- ``Swift/Array/magnitude``
- ``Swift/Array/normalized``

### Vector Relationships 
- ``Swift/Array/dot(_:)``
- ``Swift/Array/angle(with:)-piry``
- ``Swift/Array/angleInDegrees(with:)-7n2tx``
- ``Swift/Array/cosineOfAngle(with:)``
- ``Swift/Array/averaged()``

### Vector Projections
- ``Swift/Array/scalarProjection(onto:)``
- ``Swift/Array/vectorProjection(onto:)``
- ``Swift/Array/orthogonalComponent(to:)``

### Matrix Operations
- ``Swift/Array/transformedBy(_:)``

### Related Articles
- <doc:Primer>
