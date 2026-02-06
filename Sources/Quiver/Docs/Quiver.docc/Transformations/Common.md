# Common Transformations

Apply rotation, scaling, reflection, and shear transformations using transformation matrices.

## Overview

After understanding how transformation matrices work (see <doc:Fundamentals>), we can construct specific matrices for common geometric operations. These transformations are fundamental to graphics programming, game development, computer vision, and spatial computing.

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

### Common rotations

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

### Practical examples

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
    // Creates diagonal matrix with factor on diagonal, zeros elsewhere
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

### Practical examples

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

### Practical examples

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

### Practical examples

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

## Combining transformation properties

### Preserving properties

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

## See also

- <doc:Fundamentals>
- <doc:Composition>
- <doc:Matrices-Operations>
- <doc:Operations>

## Topics

### Transformation operations
- ``Swift/Array/transformedBy(_:)``

### Matrix creation
- ``Swift/Array/diag(_:)``
- ``Swift/Array/identity(_:)``
