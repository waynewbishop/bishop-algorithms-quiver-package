# Common Transformations

Apply rotation, scaling, reflection, and shear transformations using transformation matrices.

## Overview

After understanding how transformation matrices work (see <doc:Matrix-Transformations>), we can construct specific matrices for common geometric operations. These transformations are fundamental to graphics programming, game development, computer vision, and spatial computing.

Each transformation has a characteristic matrix form that describes how it moves the basis vectors (i-hat and j-hat). Understanding these patterns enables creating custom transformations and predicting how vectors will move.

## Rotation

Rotation transforms rotate vectors around the origin by a specified angle. In 2D, rotation is counterclockwise for positive angles.

### Common rotations

**90° counterclockwise:**
```swift
import Quiver

// Rotate vectors 90° counterclockwise around the origin
let rotate90 = [
    [0.0, -1.0],
    [1.0,  0.0]
]

// Basis vectors move: i-hat [1,0] → [0,1], j-hat [0,1] → [-1,0]

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
// Rotate vectors 180° to reverse direction
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
// Rotate vectors 45° counterclockwise
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
// Rotate vectors 90° clockwise
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
// Rotate a character's facing direction
let facingRight = [1.0, 0.0]

let facingUp = facingRight.transformedBy(rotate90)    // [0.0, 1.0]
let facingLeft = facingRight.transformedBy(rotate180)  // [-1.0, 0.0]
```

**Circular motion:**
```swift
// Move an object along a circular path around the origin
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
// Scale all axes by the same factor
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
// Stretch horizontally and compress vertically
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
// Double the size of a sprite
let scale2x = [Double].diag([2.0, 2.0])
let spriteSize = [32.0, 48.0]
let scaled = spriteSize.transformedBy(scale2x)
// Row 1: [2, 0] • [32, 48] = (2×32 + 0×48) = 64
// Row 2: [0, 2] • [32, 48] = (0×32 + 2×48) = 96
// Result: [64.0, 96.0]
```

**Aspect ratio correction:**
```swift
// Correct a 16:9 aspect ratio to square coordinates
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
// Apply a zoom level to camera coordinates
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
// Mirror a vector across the x-axis
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
// Mirror a vector across the y-axis
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
// Swap x and y coordinates by reflecting across y=x
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
// Flip a sprite to face the opposite direction
let spritePosition = [10.0, 5.0]
let mirrored = spritePosition.transformedBy(reflectY)
// [-10.0, 5.0]
```

**Water reflection:**
```swift
// Reflect an object's position below the water line
let objectPosition = [5.0, 10.0]
let waterReflection = objectPosition.transformedBy(reflectX)
// [5.0, -10.0] - 10 units below water
```

## Shear

Shear transformations "slant" the coordinate system, shifting one axis proportionally to the other. This creates a "leaning" or "skewed" effect.

**Horizontal shear (x depends on y):**
```swift
// Shift x proportionally to y with a shear factor of 0.5
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
// Shift y proportionally to x with a shear factor of 0.5
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
// Simulate italic text by leaning letters to the right
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
// Simulate depth by shifting x based on distance
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

- <doc:Matrix-Transformations>
- <doc:Composing-Transformations>
- <doc:Matrix-Operations>
- <doc:Vector-Operations>

## Topics

### Transformation operations
- ``Swift/Array/transformedBy(_:)``

### Matrix creation
- ``Swift/Array/diag(_:)``
- ``Swift/Array/identity(_:)``
