# Common Transformations

Apply rotation, scaling, reflection, and shear transformations using transformation matrices.

## Overview

After understanding how transformation matrices work (see <doc:Transformations-Fundamentals>), we can construct specific matrices for common geometric operations. These transformations are fundamental to graphics programming, game development, computer vision, and spatial computing.

Each transformation has a characteristic matrix form that describes how it moves the basis vectors (i-hat and j-hat). Understanding these patterns lets you create custom transformations and predict how vectors will move.

## Rotation

Rotation transforms rotate vectors around the origin by a specified angle. In 2D, rotation is counterclockwise for positive angles.

**Rotation by θ (theta):**
```swift
import Foundation

func rotationMatrix(angle: Double) -> [[Double]] {
    let cos_theta = cos(angle)
    let sin_theta = sin(angle)

    return [
        [cos_theta, -sin_theta],
        [sin_theta,  cos_theta]
    ]
}
```

### Common Rotations

**90° counterclockwise:**
```swift
let rotate90 = [
    [0.0, -1.0],
    [1.0,  0.0]
]

// What happens to basis vectors:
// i-hat [1,0] → [0,1] (right → up)
// j-hat [0,1] → [-1,0] (up → left)

[1.0, 0.0].transformedBy(rotate90)  // [0.0, 1.0]
[0.0, 1.0].transformedBy(rotate90)  // [-1.0, 0.0]
```

**180° (flip):**
```swift
let rotate180 = [
    [-1.0,  0.0],
    [ 0.0, -1.0]
]

[3.0, 4.0].transformedBy(rotate180)  // [-3.0, -4.0]
```

**45° counterclockwise:**
```swift
let sqrt2_2 = sqrt(2.0) / 2.0  // ≈ 0.707
let rotate45 = [
    [sqrt2_2, -sqrt2_2],
    [sqrt2_2,  sqrt2_2]
]

[1.0, 0.0].transformedBy(rotate45)
// [0.707, 0.707] - 45° between x and y axes
```

### Practical Examples

**Game character rotation:**
```swift
// Character facing right
let facingRight = [1.0, 0.0]

// Rotate to face up
let facingUp = facingRight.transformedBy(rotate90)
// [0.0, 1.0]

// Rotate to face left
let facingLeft = facingRight.transformedBy(rotate180)
// [-1.0, 0.0]
```

**Circular motion:**
```swift
// Object moving in circle, angle increases over time
let time: Double = 0.0  // Seconds
let angularSpeed = Double.pi / 2  // 90° per second
let angle = time * angularSpeed

let position = [radius, 0.0]
    .transformedBy(rotationMatrix(angle: angle))
```

## Scaling

Scaling transformations change the magnitude of vectors. Uniform scaling multiplies all dimensions equally; non-uniform scaling stretches or compresses individual axes.

**Uniform scaling (same factor all directions):**
```swift
func uniformScale(_ factor: Double) -> [[Double]] {
    [Double].diag([factor, factor])
}

// Scale by 2
let scale2x = uniformScale(2.0)
// [[2.0, 0.0],
//  [0.0, 2.0]]

[3.0, 4.0].transformedBy(scale2x)  // [6.0, 8.0]
```

**Non-uniform scaling (different per axis):**
```swift
// Stretch horizontally, compress vertically
let stretch = [
    [3.0, 0.0],
    [0.0, 0.5]
]

[2.0, 4.0].transformedBy(stretch)
// [6.0, 2.0] - 3× wider, half as tall
```

### Practical Examples

**Sprite scaling:**
```swift
// Make sprite twice as large
let sprite = [spriteWidth, spriteHeight]
let scaled = sprite.transformedBy(uniformScale(2.0))
```

**Aspect ratio correction:**
```swift
// Convert 16:9 to square
let aspectCorrection = [
    [1.0, 0.0],
    [0.0, 16.0/9.0]
]

let squareCoords = wideScreenCoords.transformedBy(aspectCorrection)
```

**Zoom effect:**
```swift
// Zoom level 1.0-3.0
let zoomLevel = 1.5
let zoom = uniformScale(zoomLevel)

let zoomedView = cameraPosition.transformedBy(zoom)
```

## Reflection

Reflection mirrors vectors across an axis or line. The transformation flips coordinates while preserving distances and angles.

**Reflect across x-axis (horizontal flip):**
```swift
let reflectX = [
    [ 1.0, 0.0],
    [ 0.0, -1.0]
]

[3.0, 4.0].transformedBy(reflectX)
// [3.0, -4.0] - x stays same, y inverted
```

**Reflect across y-axis (vertical flip):**
```swift
let reflectY = [
    [-1.0, 0.0],
    [ 0.0, 1.0]
]

[3.0, 4.0].transformedBy(reflectY)
// [-3.0, 4.0] - y stays same, x inverted
```

**Reflect across diagonal (y=x):**
```swift
let reflectDiagonal = [
    [0.0, 1.0],
    [1.0, 0.0]
]

[3.0, 4.0].transformedBy(reflectDiagonal)
// [4.0, 3.0] - x and y swapped (this is transpose!)
```

### Practical Examples

**Mirror image:**
```swift
// Flip sprite horizontally (face opposite direction)
let spritePosition = [10.0, 5.0]
let mirrored = spritePosition.transformedBy(reflectY)
// [-10.0, 5.0]
```

**Water reflection:**
```swift
// Object above water, reflection below
let objectPosition = [5.0, 10.0]  // 10 units above water
let waterReflection = objectPosition.transformedBy(reflectX)
// [5.0, -10.0] - 10 units below water
```

## Shear

Shear transformations "slant" the coordinate system, shifting one axis proportionally to the other. This creates a "leaning" or "skewed" effect.

**Horizontal shear (x depends on y):**
```swift
func shearX(_ factor: Double) -> [[Double]] {
    return [
        [1.0, factor],
        [0.0, 1.0]
    ]
}

let shear = shearX(0.5)
[2.0, 4.0].transformedBy(shear)
// [2 + 0.5×4, 4]
// [4.0, 4.0]
```

**Vertical shear (y depends on x):**
```swift
func shearY(_ factor: Double) -> [[Double]] {
    return [
        [1.0, 0.0],
        [factor, 1.0]
    ]
}

let shear = shearY(0.5)
[2.0, 4.0].transformedBy(shear)
// [2, 4 + 0.5×2]
// [2.0, 5.0]
```

### Practical Examples

**Italic text effect:**
```swift
// Lean letters to the right
let italicShear = shearX(0.3)
let letterPosition = [x, y]
let italicPosition = letterPosition.transformedBy(italicShear)
```

**Perspective projection:**
```swift
// Simple perspective (farther = more shifted)
let perspective = shearX(0.2)
let objectDepth = [x, z]  // z is depth
let screenPosition = objectDepth.transformedBy(perspective)
```

## Combining Transformation Properties

### Preserving Properties

**Rotations preserve:**
- Length (magnitude)
- Angles between vectors
- Orientation (handedness)

**Scaling preserves:**
- Ratios along axes
- Parallel lines

**Reflections preserve:**
- Distances
- Angles
- Reverse orientation (flip handedness)

**Shears preserve:**
- Areas
- Parallel lines

### Determinant and Area

The **determinant** of a transformation matrix tells you how it affects areas:

```swift
// Determinant of 2×2 matrix
func determinant(_ matrix: [[Double]]) -> Double {
    let a = matrix[0][0], b = matrix[0][1]
    let c = matrix[1][0], d = matrix[1][1]
    return a * d - b * c
}

// Examples:
determinant(rotate90)      //  1.0 - preserves area
determinant(scale2x)       //  4.0 - quadruples area (2×2)
determinant(reflectX)      // -1.0 - preserves area, flips orientation
determinant(shearX(0.5))   //  1.0 - preserves area
```

**Interpretation:**
- `det = 1`: Preserves area and orientation
- `det = -1`: Preserves area, reverses orientation
- `|det| > 1`: Expands areas
- `|det| < 1`: Shrinks areas
- `det = 0`: Collapses to lower dimension (not invertible)

## For iOS Developers

### CoreGraphics Transformations

**CGAffineTransform equivalents:**

**Rotation:**
```swift
// CoreGraphics
CGAffineTransform(rotationAngle: .pi / 2)

// Quiver (same math)
rotationMatrix(angle: .pi / 2)
```

**Scaling:**
```swift
// CoreGraphics
CGAffineTransform(scaleX: 2.0, y: 3.0)

// Quiver
[[2.0, 0.0], [0.0, 3.0]]
```

**Reflection:**
```swift
// CoreGraphics (flip vertically)
CGAffineTransform(scaleX: 1.0, y: -1.0)

// Quiver
[[1.0, 0.0], [0.0, -1.0]]
```

### SpriteKit Node Transforms

```swift
import SpriteKit
import Quiver

// Understand what SpriteKit is doing mathematically
let node = SKSpriteNode()

// SpriteKit: node.zRotation = .pi / 2
// Math: rotationMatrix(angle: .pi / 2)

// SpriteKit: node.xScale = 2.0, node.yScale = 3.0
// Math: [[2.0, 0.0], [0.0, 3.0]]
```

### RealityKit 3D Transformations

```swift
// 3D rotation around z-axis
func rotationZ(angle: Double) -> [[Double]] {
    let c = cos(angle), s = sin(angle)
    return [
        [c, -s, 0],
        [s,  c, 0],
        [0,  0, 1]
    ]
}

// 3D scaling
func scale3D(x: Double, y: Double, z: Double) -> [[Double]] {
    [Double].diag([x, y, z])
}
```

## For Python Developers

Quiver's transformations match NumPy and SciPy:

**NumPy:**
```python
import numpy as np

# Rotation
theta = np.pi / 2
rotation = np.array([
    [np.cos(theta), -np.sin(theta)],
    [np.sin(theta),  np.cos(theta)]
])

# Scaling
scaling = np.diag([2.0, 3.0])

# Apply transformation
transformed = rotation @ vector
```

**Quiver:**
```swift
// Rotation
let theta = Double.pi / 2
let rotation = rotationMatrix(angle: theta)

// Scaling
let scaling = [Double].diag([2.0, 3.0])

// Apply transformation
let transformed = vector.transformedBy(rotation)
```

## Transformation Cheat Sheet

| Transformation | Matrix | Effect | Determinant |
|----------------|--------|--------|-------------|
| Identity | `[[1,0],[0,1]]` | No change | 1 |
| Rotate 90° | `[[0,-1],[1,0]]` | Counterclockwise | 1 |
| Rotate 180° | `[[-1,0],[0,-1]]` | Half turn | 1 |
| Scale 2× | `[[2,0],[0,2]]` | Double size | 4 |
| Reflect X | `[[1,0],[0,-1]]` | Horizontal flip | -1 |
| Reflect Y | `[[-1,0],[0,1]]` | Vertical flip | -1 |
| Shear X | `[[1,s],[0,1]]` | Slant right | 1 |

## Practical Applications

### Game Character Movement

```swift
// Face character toward target
let character = [charX, charY]
let target = [targetX, targetY]

let direction = target - character
let angle = atan2(direction[1], direction[0])

let rotation = rotationMatrix(angle: angle)
let facingDirection = [1.0, 0.0].transformedBy(rotation)
```

### Camera System

```swift
// Camera looking at point with zoom
let cameraTarget = [worldX, worldY]
let zoomLevel = 2.0

// Center on target
let centered = worldPosition - cameraTarget

// Apply zoom
let zoomed = centered.transformedBy(uniformScale(zoomLevel))

// Final screen position
let screenPos = zoomed + screenCenter
```

### Sprite Batch Rendering

```swift
// Transform many sprites efficiently
let sprites: [[Double]] = loadSpritePositions()
let transform = rotationMatrix(angle: angle)
    .multiplyMatrix(uniformScale(2.0))

let transformed = sprites.map { $0.transformedBy(transform) }
```

## See Also

- <doc:Transformations-Fundamentals>
- <doc:Transformations-Composition>
- <doc:Matrices-Operations>
- <doc:Operations>

## Topics

### Transformation Operations
- ``Swift/Array/transformedBy(_:)``
- ``Swift/Array/transform(_:)``

### Matrix Creation
- ``Swift/Array/diag(_:)``
- ``Swift/Array/identity(_:)``
