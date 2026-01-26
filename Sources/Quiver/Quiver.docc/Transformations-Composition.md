# Composing Transformations

Combine multiple transformations using matrix multiplication to create complex effects.

## Overview

Individual transformations like rotation and scaling are useful, but real applications often require combining them. Matrix multiplication lets us compose multiple transformations into a single operation, creating complex effects efficiently.

Understanding transformation composition is crucial for graphics pipelines, animation systems, and any application that chains coordinate system changes.

## Matrix Multiplication

Matrix multiplication composes transformations: the result represents applying one transformation after another. Unlike regular multiplication, **order matters**.

```swift
let rotation = rotationMatrix(angle: .pi / 4)  // Rotate 45°
let scaling = [Double].diag([2.0, 2.0])        // Scale 2×

// Multiply matrices to compose transformations
let combined = rotation.multiplyMatrix(scaling)

// Apply to vector
let v = [1.0, 0.0]
let result = v.transformedBy(combined)
```

### Two Equivalent Approaches

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

## Order Matters!

Matrix multiplication is **not commutative**: `A × B ≠ B × A` in general.

```swift
let rotate90 = rotationMatrix(angle: .pi / 2)
let scale2x = [Double].diag([2.0, 1.0])  // Scale x by 2

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

### Reading Order

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

## Common Composition Patterns

### Scale then Rotate

```swift
// Make sprite 2× larger, then rotate 45°
let scale = [Double].diag([2.0, 2.0])
let rotate = rotationMatrix(angle: .pi / 4)

let scaleRotate = rotate.multiplyMatrix(scale)
// Scales sprite, then rotates it
```

**Why this order?**
- Scaling along axes is simple when aligned with x/y
- Rotation changes orientation, making subsequent scaling more complex
- Generally: scale/shear first, rotate last

### Rotate Around a Point

To rotate around a point other than origin:
1. Translate point to origin
2. Rotate
3. Translate back

```swift
// Rotate around point (px, py)
func rotateAround(point: [Double], angle: Double) -> [[Double]] {
    // This requires translation, which needs 3×3 matrices in 2D
    // Or apply as sequence:
    // 1. Shift to origin: v - point
    // 2. Rotate: result.transformedBy(rotation)
    // 3. Shift back: result + point
}

// Usage:
let pivot = [5.0, 5.0]
let angle = Double.pi / 2

let rotated = (vector - pivot)
    .transformedBy(rotationMatrix(angle: angle))
    + pivot
```

### Multiple Rotations

```swift
// Rotate 30° three times = 90° total
let rotate30 = rotationMatrix(angle: .pi / 6)

let rotate90 = rotate30
    .multiplyMatrix(rotate30)
    .multiplyMatrix(rotate30)

// Verify
[1.0, 0.0].transformedBy(rotate90)
// [0, 1] (approximately, within floating-point precision)
```

### Combining Different Transformations

```swift
// Complex transformation: scale, shear, then rotate
let scale = [Double].diag([2.0, 1.5])
let shear = shearX(0.3)
let rotate = rotationMatrix(angle: .pi / 6)

// Compose (remember: rightmost applied first)
let complex = rotate.multiplyMatrix(shear).multiplyMatrix(scale)

// Apply to many vectors efficiently
let transformed = vectors.map { $0.transformedBy(complex) }
```

## Matrix Multiplication Mechanics

For 2×2 matrices:

```swift
// A × B
let A = [[a, b], [c, d]]
let B = [[e, f], [g, h]]

let result = [
    [a*e + b*g,  a*f + b*h],
    [c*e + d*g,  c*f + d*h]
]
```

Example:
```swift
let A = [[2, 0], [0, 3]]  // Scale
let B = [[0,-1], [1, 0]]  // Rotate 90°

let C = A.multiplyMatrix(B)
// [[2*0 + 0*1, 2*(-1) + 0*0],
//  [0*0 + 3*1, 0*(-1) + 3*0]]
// = [[0, -2], [3, 0]]
```

Verify:
```swift
[1, 0].transformedBy(B)        // [0, 1] - rotated
[0, 1].transformedBy(A)        // [0, 3] - scaled
[1, 0].transformedBy(C)        // [0, 3] - rotate then scale ✓
```

## Transformation Pipelines

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

### Incremental Updates

When only one transform changes:

```swift
// Cache partial compositions
let worldToScreen = cameraToScreen.multiplyMatrix(worldToCamera)

// When object moves, only update final step
let newObjectToScreen = worldToScreen.multiplyMatrix(newObjectTransform)
```

## Inverse Transformations

Some transformations can be reversed:

**Rotation inverse:**
```swift
// Rotate θ, then rotate -θ returns to original
let rotate = rotationMatrix(angle: theta)
let unrotate = rotationMatrix(angle: -theta)

let identity = rotate.multiplyMatrix(unrotate)
// ≈ [[1,0],[0,1]] (within floating-point precision)
```

**Scaling inverse:**
```swift
// Scale by s, then scale by 1/s returns to original
let scale = [Double].diag([s, s])
let unscale = [Double].diag([1/s, 1/s])

let identity = scale.multiplyMatrix(unscale)
// [[1,0],[0,1]]
```

**General inverse:**
Not all matrices have inverses. A matrix is invertible if its determinant ≠ 0.

## Performance Optimization

### Precompute Complex Transformations

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

### Matrix Multiplication Complexity

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

## For iOS Developers

### CoreGraphics Transform Composition

**CoreGraphics:**
```swift
var transform = CGAffineTransform.identity
transform = transform.rotated(by: .pi / 4)
transform = transform.scaledBy(x: 2.0, y: 2.0)
// Implicitly composes transformations
```

**Quiver (explicit math):**
```swift
let rotate = rotationMatrix(angle: .pi / 4)
let scale = [Double].diag([2.0, 2.0])
let combined = scale.multiplyMatrix(rotate)
```

### SpriteKit Scene Graph

```swift
// Parent-child transformations compose automatically
parentNode.transform = parentTransform
childNode.transform = childTransform
// Child's world transform = parentTransform × childTransform
```

**Quiver equivalent:**
```swift
let worldTransform = parentTransform.multiplyMatrix(childTransform)
let worldPosition = localPosition.transformedBy(worldTransform)
```

### Custom Camera System

```swift
// Build camera transformation
let zoom = [Double].diag([zoomLevel, zoomLevel])
let rotation = rotationMatrix(angle: cameraAngle)
let offset = // translation (requires 3×3 matrix in 2D)

// Compose: zoom, rotate, then translate
let cameraTransform = offset
    .multiplyMatrix(rotation)
    .multiplyMatrix(zoom)
```

## For Python Developers

Quiver's composition matches NumPy:

**NumPy:**
```python
import numpy as np

A = np.array([[2, 0], [0, 3]])
B = np.array([[0, -1], [1, 0]])

# Compose transformations
C = A @ B

# Apply to vector
v = np.array([1, 0])
result = C @ v
```

**Quiver:**
```swift
let A = [[2.0, 0.0], [0.0, 3.0]]
let B = [[0.0, -1.0], [1.0, 0.0]]

// Compose transformations
let C = A.multiplyMatrix(B)

// Apply to vector
let v = [1.0, 0.0]
let result = v.transformedBy(C)
```

## Practical Applications

### Animation System

```swift
// Interpolate between two transformations
func interpolate(from start: [[Double]],
                to end: [[Double]],
                t: Double) -> [[Double]] {
    // Linear interpolation of matrix elements
    return [
        [start[0][0] + t*(end[0][0]-start[0][0]),
         start[0][1] + t*(end[0][1]-start[0][1])],
        [start[1][0] + t*(end[1][0]-start[1][0]),
         start[1][1] + t*(end[1][1]-start[1][1])]
    ]
}

// Animate rotation from 0° to 90° over time
let startRotation = [Double].identity(2)
let endRotation = rotationMatrix(angle: .pi / 2)
let currentRotation = interpolate(from: startRotation,
                                  to: endRotation,
                                  t: animationProgress)
```

### Skeletal Animation

```swift
// Bone hierarchy: shoulder → elbow → hand
let shoulderRotation = rotationMatrix(angle: shoulderAngle)
let elbowRotation = rotationMatrix(angle: elbowAngle)
let handRotation = rotationMatrix(angle: handAngle)

// Hand's world transformation
let handWorld = shoulderRotation
    .multiplyMatrix(elbowRotation)
    .multiplyMatrix(handRotation)

let handPosition = handLocalPosition.transformedBy(handWorld)
```

### Particle System

```swift
// Each particle has: position, velocity, rotation, scale
struct Particle {
    var transform: [[Double]]

    mutating func update(deltaTime: Double) {
        let rotation = rotationMatrix(angle: angularVelocity * deltaTime)
        let scale = [Double].diag([growth, growth])

        // Compose with current transform
        transform = transform
            .multiplyMatrix(rotation)
            .multiplyMatrix(scale)
    }
}
```

## Key Principles

1. **Matrix multiplication composes transformations**
   - `C = A.multiplyMatrix(B)` means "apply B, then A"

2. **Order matters**
   - `A × B ≠ B × A` in general
   - Read right-to-left: rightmost applied first

3. **Composition is efficient**
   - Compose once, apply to many vectors
   - Avoid recomputing in loops

4. **Identity is neutral**
   - `I × M = M × I = M`
   - Useful for starting composition chains

5. **Inverses undo transformations**
   - `M × M⁻¹ = I` (when inverse exists)
   - Useful for "unwind" operations

## See Also

- <doc:Transformations-Fundamentals>
- <doc:Transformations-Common>
- <doc:Matrices-Operations>
- <doc:Operations>

## Topics

### Matrix Multiplication
- ``Swift/Array/multiplyMatrix(_:)``

### Transformation Operations
- ``Swift/Array/transformedBy(_:)``
- ``Swift/Array/transform(_:)``

### Matrix Creation
- ``Swift/Array/identity(_:)``
- ``Swift/Array/diag(_:)``
