# Understanding Transformations

Learn how matrices transform vector spaces through basis vectors and the identity matrix.

## Overview

> Tip: For an in-depth exploration of transformation matrices with geometric examples, see [Chapter 22: Matrix Transformations](https://waynewbishop.github.io/swift-algorithms/22-transformations.html) in Swift Algorithms & Data Structures.

Matrices serve two purposes: organizing data (see <doc:Matrices-Operations>) and **transforming** vector spaces. While a matrix can represent a table of numbers, it can also represent a coordinate system transformation—rotating, scaling, reflecting, or shearing vectors in space.

Understanding transformations is essential for graphics programming, game development, computer vision, AR/VR applications, and any domain requiring coordinate system manipulations.

## Basis Vectors

Every coordinate system is defined by **basis vectors**—the fundamental directions that define the axes. In 2D, we conventionally use two unit vectors:

```swift
let iHat = [1.0, 0.0]  // Points right along x-axis
let jHat = [0.0, 1.0]  // Points up along y-axis
```

Visually:
```
        ↑ j-hat [0, 1]
        |
        |
        └──→ i-hat [1, 0]
```

**Any** vector can be expressed as a combination of these basis vectors:

```swift
let v = [3.0, 4.0]

// This means:
// v = 3 × iHat + 4 × jHat
// v = 3 × [1, 0] + 4 × [0, 1]
// v = [3, 0] + [0, 4]
// v = [3, 4]
```

The coordinates `[3, 4]` tell us "move 3 units in the i-hat direction, then 4 units in the j-hat direction."

### Basis Vectors Define the Canvas

Think of basis vectors as defining your coordinate system's "canvas":
- **i-hat** defines what "right" means
- **j-hat** defines what "up" means
- All other vectors are built from these

When we **transform** vectors, we're actually changing where these basis vectors point. The same coordinates `[3, 4]` in a transformed space mean "3 units along the new i-hat, 4 units along the new j-hat."

## The Identity Matrix

The **identity matrix** represents the standard, untransformed coordinate system. Its columns are simply the basis vectors:

```swift
let identity = [
    [1.0, 0.0],  // Column 1: i-hat
    [0.0, 1.0]   // Column 2: j-hat
]
```

Or in Quiver:
```swift
let identity = [Double].identity(2)
// [[1.0, 0.0],
//  [0.0, 1.0]]
```

### Properties of Identity Matrix

**Transforming by identity doesn't change vectors:**
```swift
let v = [3.0, 4.0]
let unchanged = v.transformedBy(identity)
// [3.0, 4.0] - exactly the same
```

**Why?** Because identity says "keep i-hat pointing right at [1,0], keep j-hat pointing up at [0,1]." Nothing changes.

**Matrix multiplication:**
```swift
let someMatrix = [[2.0, 0.0], [0.0, 3.0]]

// Identity × M = M
identity.multiplyMatrix(someMatrix) == someMatrix  // true

// M × Identity = M
someMatrix.multiplyMatrix(identity) == someMatrix  // true
```

Identity is the multiplicative neutral element for matrices, like how 1 is for numbers:
- `1 × x = x`
- `I × M = M` (where I is identity)

## Reading Transformation Matrices

A transformation matrix tells you **where the basis vectors land** after transformation:

```swift
let transformation = [
    [a, c],  // Where i-hat [1,0] goes
    [b, d]   // Where j-hat [0,1] goes
]
```

**Example - Rotation 90° counterclockwise:**
```swift
let rotate90 = [
    [0.0, -1.0],  // i-hat [1,0] → [0,1] (up)
    [1.0,  0.0]   // j-hat [0,1] → [-1,0] (left)
]

// Wait, the columns look backwards!
// Remember: each COLUMN shows where a basis vector goes
// Column 1: [0, 1] - where i-hat ends up
// Column 2: [-1, 0] - where j-hat ends up
```

Let's verify:
```swift
let right = [1.0, 0.0]  // Points right
let rotated = right.transformedBy(rotate90)
// [0.0, 1.0] - now points up! ✓
```

### Visualizing Transformations

Before transformation (identity):
```
    ↑ j-hat
    |
    |
    └──→ i-hat
```

After 90° rotation:
```
←── j-hat
|
|
↑ i-hat
```

The vector `[2, 1]` means:
- **Before**: 2 right + 1 up = `[2, 1]`
- **After**: 2 up + 1 left = `[-1, 2]`

```swift
[2.0, 1.0].transformedBy(rotate90)  // [-1.0, 2.0] ✓
```

## Matrix-Vector Multiplication

When we multiply a matrix by a vector, we're asking: "Where does this vector land in the transformed space?"

```swift
let transformation = [
    [2.0, 0.0],  // i-hat → [2, 0] (stretched 2× along x)
    [0.0, 3.0]   // j-hat → [0, 3] (stretched 3× along y)
]

let v = [4.0, 5.0]
// Means: 4 × i-hat + 5 × j-hat

let result = v.transformedBy(transformation)
// 4 × [2,0] + 5 × [0,3]
// [8,0] + [0,15]
// [8, 15]
```

The math:
```
[2  0] [4]   [2×4 + 0×5]   [8]
[0  3] [5] = [0×4 + 3×5] = [15]
```

### Two Equivalent Syntaxes

Quiver provides two ways to express the same operation:

**Vector perspective** (vector being transformed):
```swift
let transformed = vector.transformedBy(matrix)
```

**Matrix perspective** (matrix acting on vector):
```swift
let transformed = matrix.transform(vector)
```

Both produce identical results. Choose based on what you want to emphasize:
- Use `.transformedBy()` when focusing on the vector
- Use `.transform()` when focusing on the transformation

## Creating Transformation Matrices

### Identity

```swift
let identity2D = [Double].identity(2)
let identity3D = [Double].identity(3)
```

### Diagonal Matrices (Scaling)

```swift
// Scale x by 2, y by 3
let scale = [Double].diag([2.0, 3.0])
// [[2.0, 0.0],
//  [0.0, 3.0]]
```

Diagonal matrices scale each axis independently:
```swift
let v = [4.0, 5.0]
let scaled = v.transformedBy(scale)
// [8.0, 15.0] - x scaled by 2, y scaled by 3
```

## Practical Examples

### Example 1: Uniform Scaling

```swift
// Scale everything by 2
let scale2x = [
    [2.0, 0.0],
    [0.0, 2.0]
]

// Or using diag:
let scale2x = [Double].diag([2.0, 2.0])

[3.0, 4.0].transformedBy(scale2x)
// [6.0, 8.0] - doubled in both dimensions
```

### Example 2: Non-Uniform Scaling

```swift
// Stretch horizontally, compress vertically
let stretch = [
    [3.0, 0.0],   // i-hat × 3
    [0.0, 0.5]    // j-hat × 0.5
]

[2.0, 4.0].transformedBy(stretch)
// [6.0, 2.0] - wider but shorter
```

### Example 3: Identity Verification

```swift
let identity = [Double].identity(2)
let v = [5.0, 7.0]

v.transformedBy(identity) == v  // true - no change
```

## For iOS Developers

Quiver's transformation matrices directly correspond to iOS frameworks:

### CoreGraphics

**CoreGraphics:**
```swift
var transform = CGAffineTransform.identity
transform = transform.scaledBy(x: 2.0, y: 2.0)
```

**Quiver (underlying math):**
```swift
let transform = [Double].identity(2)
let scaled = [Double].diag([2.0, 2.0])
```

The CGAffineTransform is a 3×3 matrix for 2D transformations (includes translation). Quiver shows you the mathematical foundation.

### SpriteKit/SceneKit

**SpriteKit:**
```swift
let sprite = SKSpriteNode()
sprite.setScale(2.0)  // Uniform scaling
sprite.xScale = 3.0   // Non-uniform scaling
sprite.yScale = 0.5
```

**Quiver (the math):**
```swift
let uniform = [Double].diag([2.0, 2.0])
let nonUniform = [Double].diag([3.0, 0.5])
```

Understanding the matrix math helps you:
- Combine transformations correctly
- Debug transform issues
- Implement custom transforms
- Optimize transformation sequences

### RealityKit/ARKit

**RealityKit:**
```swift
var transform = Transform()
transform.scale = [2, 2, 2]  // 3D scaling
```

**Quiver (3D matrix):**
```swift
let scale3D = [Double].diag([2.0, 2.0, 2.0])  // 3×3 matrix
```

## For Python Developers

Quiver's transformations match NumPy linear algebra:

**NumPy:**
```python
import numpy as np

identity = np.eye(2)
vector = np.array([3, 4])
transformed = identity @ vector
```

**Quiver:**
```swift
let identity = [Double].identity(2)
let vector = [3.0, 4.0]
let transformed = vector.transformedBy(identity)
```

## Geometric Intuition

Transformations change the **coordinate system**, not just the vector:

**Before transformation:**
- A unit square has corners at `[0,0]`, `[1,0]`, `[1,1]`, `[0,1]`

**After scaling by [2, 3]:**
- The "unit square" in the new system has corners at `[0,0]`, `[2,0]`, `[2,3]`, `[0,3]`
- The coordinates `[1,1]` now mean [2,3] in the original space

This perspective helps understand:
- Why matrix multiplication order matters
- How transformations compose
- Why some transformations are invertible

## Key Principles

1. **Basis vectors define the coordinate system**
   - Standard basis: i-hat = [1,0], j-hat = [0,1]
   - Transformed basis: columns of the transformation matrix

2. **Identity matrix = no transformation**
   - Keeps basis vectors unchanged
   - Neutral element for matrix multiplication

3. **Matrix columns show where basis vectors go**
   - Column 1: where [1,0] goes
   - Column 2: where [0,1] goes

4. **Coordinates are coefficients of basis vectors**
   - [3,4] means 3×i-hat + 4×j-hat
   - Same in any coordinate system

## See Also

- <doc:Common>
- <doc:Composition>
- <doc:Matrices-Operations>
- <doc:Operations>

## Topics

### Matrix Creation
- ``Swift/Array/identity(_:)``
- ``Swift/Array/diag(_:)``

### Transformation Operations
- ``Swift/Array/transformedBy(_:)``
- ``Swift/Array/transform(_:)``
