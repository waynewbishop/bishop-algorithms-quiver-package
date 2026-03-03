# Common Transformations

Apply rotation, scaling, reflection, and shear transformations using transformation matrices.

## Overview

After understanding how transformation matrices work (see <doc:Transformation-Basics>), we can construct specific matrices for common geometric operations. These transformations are fundamental to graphics programming, game development, computer vision, and spatial computing.

Each transformation has a characteristic matrix form that describes how it moves the basis vectors (i-hat and j-hat). Understanding these patterns enables creating custom transformations and predicting how vectors will move.

## Rotation

Rotation transforms rotate vectors around the origin by a specified angle. In 2D, rotation is counterclockwise for positive angles.

### Common rotations

**90° counterclockwise:**
```swift
import Quiver

// 90° counterclockwise rotation
let rotate90 = [
    [0.0, -1.0],
    [1.0,  0.0]
]

// What happens to basis vectors:
// i-hat [1,0] → [0,1] (right → up)
// j-hat [0,1] → [-1,0] (up → left)

[1.0, 0.0].transformedBy(rotate90)
// Row 1: [0, -1] • [1, 0] = (0×1 + (-1)×0) = 0
// Row 2: [1,  0] • [1, 0] = (1×1 +   0×0)  = 1
// Result: [0.0, 1.0]

[0.0, 1.0].transformedBy(rotate90)
// Row 1: [0, -1] • [0, 1] = (0×0 + (-1)×1) = -1
// Row 2: [1,  0] • [0, 1] = (1×0 +   0×1)  =  0
// Result: [-1.0, 0.0]
```

**180° (flip):**
```swift
// 180° rotation
let rotate180 = [
    [-1.0,  0.0],
    [ 0.0, -1.0]
]

[3.0, 4.0].transformedBy(rotate180)
// Row 1: [-1, 0] • [3, 4] = ((-1)×3 + 0×4) = -3
// Row 2: [0, -1] • [3, 4] = (0×3 + (-1)×4) = -4
// Result: [-3.0, -4.0]
```

**45° counterclockwise:**
```swift
// 45° counterclockwise rotation
let rotate45 = [
    [0.707, -0.707],
    [0.707,  0.707]
]

[1.0, 0.0].transformedBy(rotate45)
// Row 1: [0.707, -0.707] • [1, 0] = (0.707×1 + (-0.707)×0) = 0.707
// Row 2: [0.707,  0.707] • [1, 0] = (0.707×1 +   0.707×0)  = 0.707
// Result: [0.707, 0.707] — 45° between x and y axes
```

**90° clockwise:**
```swift
// 90° clockwise rotation (negative angle flips the sign of sin)
let rotate90cw = [
    [ 0.0, 1.0],
    [-1.0, 0.0]
]

[1.0, 0.0].transformedBy(rotate90cw)
// Row 1: [0,  1] • [1, 0] = (0×1 + 1×0)    =  0
// Row 2: [-1, 0] • [1, 0] = ((-1)×1 + 0×0) = -1
// Result: [0.0, -1.0] — vector now points down
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
// Object at radius 5, rotated 90° around the origin
let radius = 5.0
let position = [radius, 0.0].transformedBy(rotate90)
// Row 1: [0, -1] • [5, 0] = (0×5 + (-1)×0) = 0
// Row 2: [1,  0] • [5, 0] = (1×5 +   0×0)  = 5
// Result: [0.0, 5.0]
```

## Scaling

Scaling transformations change the magnitude of vectors. Uniform scaling multiplies all dimensions equally; non-uniform scaling stretches or compresses individual axes.

**Uniform scaling (same factor all directions):**
```swift
// Scale by 2 — diagonal matrix with factor on diagonal
let scale2x = [Double].diag([2.0, 2.0])
// [[2.0, 0.0],
//  [0.0, 2.0]]

[3.0, 4.0].transformedBy(scale2x)
// Row 1: [2, 0] • [3, 4] = (2×3 + 0×4) = 6
// Row 2: [0, 2] • [3, 4] = (0×3 + 2×4) = 8
// Result: [6.0, 8.0]
```

**Non-uniform scaling (different per axis):**
```swift
// Stretch horizontally (3×), compress vertically (0.5×)
let stretch = [
    [3.0, 0.0],
    [0.0, 0.5]
]

[2.0, 4.0].transformedBy(stretch)
// Row 1: [3, 0]   • [2, 4] = (3×2 + 0×4)   = 6
// Row 2: [0, 0.5] • [2, 4] = (0×2 + 0.5×4) = 2
// Result: [6.0, 2.0] — 3× wider, half as tall
```

### Practical examples

**Sprite scaling:**
```swift
// Make sprite twice as large
let scale2x = [Double].diag([2.0, 2.0])
let spriteSize = [32.0, 48.0]  // Width × height in points
let scaled = spriteSize.transformedBy(scale2x)
// Row 1: [2, 0] • [32, 48] = (2×32 + 0×48) = 64
// Row 2: [0, 2] • [32, 48] = (0×32 + 2×48) = 96
// Result: [64.0, 96.0]
```

**Aspect ratio correction:**
```swift
// Convert 16:9 to square
let aspectCorrection = [
    [1.0, 0.0],
    [0.0, 16.0/9.0]
]

let wideScreen = [16.0, 9.0]
let squareCoords = wideScreen.transformedBy(aspectCorrection)
// Row 1: [1, 0]     • [16, 9] = (1×16 + 0×9)         = 16
// Row 2: [0, 1.778] • [16, 9] = (0×16 + 1.778×9) ≈ 16
// Result: [16.0, 16.0]
```

**Zoom effect:**
```swift
// Zoom level 1.0-3.0
let zoomLevel = 1.5
let zoom = [Double].diag([zoomLevel, zoomLevel])

let cameraCenter = [100.0, 75.0]
let zoomedView = cameraCenter.transformedBy(zoom)
// Row 1: [1.5, 0]   • [100, 75] = (1.5×100 + 0×75) = 150
// Row 2: [0,   1.5] • [100, 75] = (0×100 + 1.5×75)  = 112.5
// Result: [150.0, 112.5]
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
// Row 1: [1,  0] • [3, 4] = (1×3 +  0×4) =  3
// Row 2: [0, -1] • [3, 4] = (0×3 + (-1)×4) = -4
// Result: [3.0, -4.0] — x stays same, y inverted
```

**Reflect across y-axis (vertical flip):**
```swift
let reflectY = [
    [-1.0, 0.0],
    [ 0.0, 1.0]
]

[3.0, 4.0].transformedBy(reflectY)
// Row 1: [-1, 0] • [3, 4] = ((-1)×3 + 0×4) = -3
// Row 2: [ 0, 1] • [3, 4] = (0×3 + 1×4)    =  4
// Result: [-3.0, 4.0] — y stays same, x inverted
```

**Reflect across diagonal (y=x):**
```swift
let reflectDiagonal = [
    [0.0, 1.0],
    [1.0, 0.0]
]

[3.0, 4.0].transformedBy(reflectDiagonal)
// Row 1: [0, 1] • [3, 4] = (0×3 + 1×4) = 4
// Row 2: [1, 0] • [3, 4] = (1×3 + 0×4) = 3
// Result: [4.0, 3.0] — x and y swapped (this is transpose!)
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
// Horizontal shear with factor 0.5
let shearH = [
    [1.0, 0.5],
    [0.0, 1.0]
]

[2.0, 4.0].transformedBy(shearH)
// Row 1: [1, 0.5] • [2, 4] = (1×2 + 0.5×4) = 4
// Row 2: [0, 1]   • [2, 4] = (0×2 + 1×4)   = 4
// Result: [4.0, 4.0]
```

**Vertical shear (y depends on x):**
```swift
// Vertical shear with factor 0.5
let shearV = [
    [1.0, 0.0],
    [0.5, 1.0]
]

[2.0, 4.0].transformedBy(shearV)
// Row 1: [1,   0] • [2, 4] = (1×2 + 0×4)   = 2
// Row 2: [0.5, 1] • [2, 4] = (0.5×2 + 1×4) = 5
// Result: [2.0, 5.0]
```

### Practical examples

**Italic text effect:**
```swift
// Lean letters to the right with horizontal shear
let italicShear = [
    [1.0, 0.3],
    [0.0, 1.0]
]

let letterPosition = [10.0, 20.0]
let italicPosition = letterPosition.transformedBy(italicShear)
// Row 1: [1, 0.3] • [10, 20] = (1×10 + 0.3×20) = 16
// Row 2: [0, 1]   • [10, 20] = (0×10 + 1×20)    = 20
// Result: [16.0, 20.0]
```

**Perspective projection:**
```swift
// Simple perspective (farther = more shifted)
let perspective = [
    [1.0, 0.2],
    [0.0, 1.0]
]

let objectDepth = [5.0, 10.0]  // x position and z depth
let screenPosition = objectDepth.transformedBy(perspective)
// Row 1: [1, 0.2] • [5, 10] = (1×5 + 0.2×10) = 7
// Row 2: [0, 1]   • [5, 10] = (0×5 + 1×10)   = 10
// Result: [7.0, 10.0]
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

- <doc:Transformation-Basics>
- <doc:Composition>
- <doc:Matrices-Operations>
- <doc:Operations>

## Topics

### Transformation operations
- ``Swift/Array/transformedBy(_:)``

### Matrix creation
- ``Swift/Array/diag(_:)``
- ``Swift/Array/identity(_:)``
