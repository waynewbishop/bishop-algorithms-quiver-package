# Linear Algebra Primer

A concise introduction to essential linear algebra concepts using Quiver.

## Overview

Linear algebra forms the mathematical foundation for many fields including computer graphics, machine learning, data analysis, and physics simulations. This primer introduces key concepts through practical Swift code examples using Quiver.

You don't need advanced mathematical knowledge to get started—if you can work with Swift arrays, you can begin applying linear algebra concepts in your code.

### Vectors: More Than Just Arrays

In programming, we often use arrays to store collections of values. In linear algebra, these become "vectors" which represent quantities with both `magnitude` (size) and direction.

```swift
// A 2D vector representing a point or direction
let v = [3.0, 4.0]

// Find the magnitude (length) of the vector
let magnitude = v.magnitude  // 5.0

// Create a unit vector (same direction, length of 1)
let unitVector = v.normalized  // [0.6, 0.8]
```

> Tip: The Pythagorean theorem is used to calculate vector magnitude: √(3² + 4²) = 5

Vectors can represent many real-world concepts:
- Positions in space
- Forces or velocities in physics
- Features in machine learning
- RGB color values

### Vector Operations: Relationships Between Vectors

Vector operations reveal relationships between vectors and enable transformations.

#### Dot Product: Measuring Alignment

The dot product measures how parallel two vectors are:

```swift
let v1 = [1.0, 0.0]  // Points right
let v2 = [0.0, 1.0]  // Points up

// Dot product of perpendicular vectors is zero
v1.dot(v2)  // 0.0

// Dot product of parallel vectors equals their magnitude product
v1.dot(v1)  // 1.0
```

Applications include:
- Determining if vectors are perpendicular (dot product = 0)
- Calculating work in physics (force × distance)
- Finding projections of one vector onto another

#### Vector Projection: Breaking Down Components

Projection decomposes one vector into components relative to another:

```swift
let force = [5.0, 5.0]  // Force vector at 45°
let direction = [1.0, 0.0]  // Direction (right)

// How much force is applied in this direction?
let componentInDirection = force.scalarProjection(onto: direction)  // 5.0

// Vector component in this direction
let forceInDirection = force.vectorProjection(onto: direction)  // [5.0, 0.0]

// Vector component perpendicular to direction
let forcePerpendicular = force.orthogonalComponent(to: direction)  // [0.0, 5.0]
```

> Note: Vector projection is essential in physics for resolving forces and in graphics for light calculations.

### Matrices: Organizing Data and Transformations

Matrices are rectangular arrays of numbers. In Quiver, we represent them as arrays of arrays:

```swift
// A 2×3 matrix (2 rows, 3 columns)
let matrix = [
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0]
]
```

Matrices serve two primary purposes:
1. Organizing data (rows might be samples, columns might be features)
2. Representing transformations (rotations, scaling, etc.)

#### Matrix Creation

Quiver makes it easy to create common matrices:

```swift
// Create a 3×3 identity matrix
let identity = [Double].identity(3)
// [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]

// Create a matrix of zeros
let zeros = [Double].zeros(2, 3)
// [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]
```

#### Transforming with Matrices

One of the most powerful applications of matrices is transforming vectors:

```swift
// A 2D rotation matrix (90° counterclockwise)
let rotationMatrix = [
    [0.0, -1.0],
    [1.0,  0.0]
]

// A vector to transform
let v = [3.0, 1.0]

// Apply the rotation
let rotated = v.transformedBy(rotationMatrix)  // [-1.0, 3.0]
```

> Important: For a matrix to transform a vector, the matrix width must match the vector length.

Common transformations include:
- Rotation (changes direction)
- Scaling (changes magnitude)
- Reflection (mirrors across an axis)
- Shear (shifts proportionally to distance)

### Practical Applications

Let's examine some real-world applications of these concepts.

#### Image Processing: RGB Color Adjustment

```swift
// RGB color values as a vector
let color = [0.8, 0.5, 0.2]  // Amber color

// Brightness adjustment (scaling)
let brighterColor = color * 1.2  // [0.96, 0.6, 0.24]

// Grayscale transformation matrix
let grayscaleMatrix = [
    [0.299, 0.587, 0.114],
    [0.299, 0.587, 0.114],
    [0.299, 0.587, 0.114]
]

// Convert to grayscale
let grayColor = color.transformedBy(grayscaleMatrix)
// [~0.5, ~0.5, ~0.5]
```

#### Physics: Force Calculation

```swift
// Calculate the work done by a force
let force = [5.0, 3.0, 2.0]  // Force vector in 3D space
let distance = [10.0, 0.0, 0.0]  // Movement along x-axis only

// Work = Force · Distance (dot product)
let work = force.dot(distance)  // 50.0

// Effective force in the direction of movement
let effectiveForce = force.vectorProjection(onto: distance)
// [5.0, 0.0, 0.0]
```

#### Machine Learning: Feature Similarity

```swift
// Feature vectors for two products
let product1 = [4.2, 7.8, 3.1, 9.5]  // Features like price, rating, etc.
let product2 = [3.8, 8.2, 2.9, 9.7]

// Cosine similarity (normalized dot product)
let similarity = product1.cosineOfAngle(with: product2)  // ~0.998
```

### Beyond the Basics

This primer covers fundamental concepts, but linear algebra goes much deeper. As you get comfortable with these basics, explore:

- Eigenvalues and eigenvectors
- Matrix decomposition
- Singular value decomposition (SVD)
- Principal component analysis (PCA)

> Tip: The best way to learn is by applying these concepts in real projects. Start small and build intuition through practice.

