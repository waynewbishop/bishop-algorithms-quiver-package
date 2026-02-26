# Determinants Primer

Understand how matrices scale spacen and assess numerical stability.

## Overview

Every square matrix has a single number associated with it called the **determinant**. This value answers a geometric question: when the matrix transforms space, how much does the area (or volume) change? A determinant of `2` means the transformation doubles all areas. A determinant of `-1` means areas stay the same size but orientation flips. A determinant of `0` means the transformation crushes space down to a lower dimension — and that has serious consequences for whether we can undo the transformation.

> Note: This primer builds on concepts from the <doc:Primer>. Familiarity with vectors, matrices, and transformations will help, but the examples are self-contained.

## Scaling space

A matrix transforms every vector in a coordinate system. The simplest case is a diagonal matrix, which scales each axis independently. Consider a matrix that stretches space by a factor of `3` horizontally and `5` vertically:

```swift
import Quiver

let scale = [[3.0, 0.0],
             [0.0, 5.0]]
scale.determinant  // 15.0
```

The original `1`×`1` unit square becomes a `3`×`5` rectangle with area `15`. The determinant captures this scaling factor directly — it tells us that every region in the original space is now `15` times larger.

Adding a shear component tilts the rectangle into a parallelogram, but the area does not change. The base-times-height calculation still produces the same result:

```swift
let shear = [[3.0, 0.0],
             [2.0, 5.0]]
shear.determinant  // 15.0
```

For a general `2`×`2` matrix, the determinant equals `ad - bc`. This formula computes the signed area of the parallelogram formed by the transformed basis vectors:

```swift
let general = [[3.0, 1.0],
               [2.0, 5.0]]
general.determinant  // 13.0 = (3 × 5) - (1 × 2)
```

The sign matters. A negative determinant means the transformation flips orientation — like looking at space in a mirror. A rotation matrix, which preserves both area and orientation, always has a determinant of `1`:

```swift
// 90° counterclockwise rotation
let rotation = [[0.0, -1.0],
                [1.0,  0.0]]
rotation.determinant  // 1.0 (area preserved, no flip)
```

### Higher dimensions

The same principle extends naturally. For a `3`×`3` matrix, the determinant measures volume scaling. For an `n`×`n` matrix, it measures the scaling of n-dimensional volume. Quiver handles any size:

```swift
let matrix3x3 = [
    [1.0, 2.0, 3.0],
    [0.0, 1.0, 4.0],
    [5.0, 6.0, 0.0]
]
matrix3x3.determinant  // 1.0
```

## When the determinant is zero

A determinant of zero signals that the matrix is **singular** — it collapses space into a lower dimension. In 2D, the transformation flattens everything onto a line. In 3D, it compresses a volume into a plane or a line.

Consider a matrix where both columns point in the same direction:

```swift
let singular = [[1.0, 2.0],
                [1.0, 2.0]]
singular.determinant  // 0.0
```

Both transformed basis vectors land on the line `y = x`. Every point in 2D space gets mapped onto that single line, losing an entire dimension of information. We cannot reconstruct the original 2D positions from a 1D line, so no inverse exists.

The same principle applies to larger matrices. When one row is a linear combination of the others, the system of equations the matrix represents is underdetermined:

```swift
let dependent = [
    [1.0, 1.0, 3.0],
    [1.0, 2.0, 4.0],
    [2.0, 3.0, 7.0]   // row 1 + row 2
]
dependent.determinant  // 0.0
```

The third equation adds no new information. We have three unknowns but only two independent equations — not enough to find a unique solution.

> Important: Attempting to call `.inverted()` on a singular matrix results in a fatal error. Always check the determinant first, or use `.conditionNumber` for a safer diagnostic.

### Why this matters in practice

Singular matrices appear more often than we might expect. In machine learning, a feature matrix becomes singular when one feature is a perfect linear combination of others. In computer graphics, a transformation that projects 3D objects onto a 2D screen is inherently singular — we lose the depth dimension, and that loss is by design.

## Matrix inversion

When a matrix has a non-zero determinant, we can compute its inverse. The inverse matrix undoes the original transformation: if matrix A rotates a vector `90`° clockwise, then A⁻¹ rotates it `90`° counterclockwise, returning it to its original position.

```swift
let A = [[3.0, 1.0],
         [2.0, 5.0]]

let inv = A.inverted()
let identity = A.multiplyMatrix(inv)
// [[1.0, 0.0],
//  [0.0, 1.0]]
```

The product A × A⁻¹ always equals the identity matrix — the transformation that leaves everything unchanged. The determinant connects directly to inversion: the determinant of the inverse equals the reciprocal of the original determinant:

```swift
A.determinant             // 13.0
A.inverted().determinant  // 0.0769... (1/13)
```

This makes geometric sense. If the original transformation scales area by a factor of `13`, undoing that transformation must scale area by `1/13` to restore the original size.

### Solving linear systems

One of the most practical applications of matrix inversion is solving systems of linear equations. Given the system Ax = b, the solution is x = A⁻¹b:

```swift
// System: 3x + y = 10, 2x + 5y = 27
let A = [[3.0, 1.0],
         [2.0, 5.0]]
let b = [10.0, 27.0]

let solution = b.transformedBy(A.inverted())
// [1.77, 4.69]
```

This only works when the determinant is non-zero. A zero determinant means the equations are either contradictory (no solution) or redundant (infinitely many solutions).

## Condition number

A matrix can have a non-zero determinant and still produce unreliable results when inverted. The **condition number** quantifies this risk by measuring how sensitive the result is to small changes in the input.

```swift
let identity = [[1.0, 0.0],
                [0.0, 1.0]]
identity.conditionNumber  // 1.0 (perfectly conditioned)
```

A condition number near `1.0` means the matrix is well-behaved. As the value grows, the matrix becomes increasingly ill-conditioned — small rounding errors in the input get amplified into large errors in the output:

```swift
let nearSingular = [[1.0, 1.0],
                    [1.0, 1.0000001]]
nearSingular.determinant      // 0.0000001 (non-zero, technically invertible)
nearSingular.conditionNumber  // > 1,000,000 (inversion results are unreliable)
```

This matrix has a tiny but non-zero determinant, so `.inverted()` returns a result — but that result is numerically unreliable. The condition number catches what the determinant alone misses.

**Interpreting the condition number:**

- Near `1.0`: Well-conditioned, safe to invert
- `10³`–`10⁶`: Moderate conditioning, results may lose precision
- Above `10⁶`: Ill-conditioned, inversion results are unreliable
- Infinity: Singular matrix, no inverse exists

```swift
let singular = [[1.0, 2.0],
                [2.0, 4.0]]
singular.conditionNumber  // .infinity
```

Quiver computes the condition number using the **1-norm** (maximum absolute column sum), which is the same approach used by LAPACK and NumPy.

### When to check the condition number

In production code, checking the condition number before inverting a matrix prevents silent numerical failures. A recommendation engine computing user-item similarity matrices, a physics simulation solving force equations, or a calibration system fitting sensor data — all benefit from knowing whether their matrix is safe to invert before trusting the result.

```swift
let matrix = [[4.0, 1.0],
              [1.0, 3.0]]

let cond = matrix.conditionNumber
if cond < 1_000 {
    let inverse = matrix.inverted()
    // Safe to use the inverse
} else {
    // Matrix is ill-conditioned — consider regularization
}
```

## Log determinant

For large matrices, the determinant can overflow or underflow the range of `Double`. A `100`×`100` matrix with moderately large entries might produce a determinant of `10³⁰⁰`, which exceeds what floating-point numbers can represent. A matrix with small entries might produce a determinant so close to zero that it rounds to exactly `0.0`, becoming indistinguishable from a truly singular matrix.

The `logDeterminant` property solves this by working in log-space. Instead of computing the product of pivot values directly (which overflows), it sums their logarithms (which stays in a manageable range). The result separates the **sign** from the **magnitude**:

```swift
let A = [[4.0, 3.0],
         [6.0, 3.0]]
let ld = A.logDeterminant
ld.sign         // -1.0 (determinant is negative)
ld.logAbsValue  // 1.7918 (natural log of 6)
ld.value        // -6.0 (reconstructed: sign × exp(logAbsValue))
```

The `LogDeterminant` struct provides three properties:
- `sign` — the sign of the determinant: `-1.0`, `0.0`, or `1.0`
- `logAbsValue` — the natural logarithm of the absolute determinant
- `value` — the reconstructed determinant (useful for small matrices where overflow is not a concern)

For larger matrices, the log form stays well within floating-point range while the raw product would approach overflow:

```swift
let large = [
    [10.0, 0.0, 0.0, 0.0, 0.0],
    [0.0, 20.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 30.0, 0.0, 0.0],
    [0.0, 0.0, 0.0, 40.0, 0.0],
    [0.0, 0.0, 0.0, 0.0, 50.0]
]
let ld = large.logDeterminant
ld.logAbsValue  // 16.52 (manageable)
ld.value        // 12000000 (reconstructed)
```

Singular matrices return a sign of zero and a log value of negative infinity:

```swift
let singular = [[1.0, 2.0],
                [2.0, 4.0]]
let ld = singular.logDeterminant
ld.sign         // 0.0
ld.logAbsValue  // -infinity
```

**NumPy equivalent:**
```python
import numpy as np
sign, logdet = np.linalg.slogdet(matrix)
```

### Comparing determinants safely

The log form is especially useful when comparing the determinants of multiple matrices. Instead of comparing raw values that might be astronomically large or vanishingly small, we compare their logarithms — which are ordinary, well-behaved numbers:

```swift
let matrixA = [[10.0, 0.0], [0.0, 10.0]]
let matrixB = [[5.0, 0.0], [0.0, 20.0]]

// Compare in log-space
let ldA = matrixA.logDeterminant
let ldB = matrixB.logDeterminant

ldA.logAbsValue  // 4.605 (log of 100)
ldB.logAbsValue  // 4.605 (log of 100)
// Same scaling factor, different axis distributions
```

## Putting it all together

These three operations form a diagnostic chain. Before inverting a matrix in a production pipeline, we can verify the operation is safe:

```swift
let matrix = [[4.0, 7.0],
              [2.0, 6.0]]

// Step 1: Is it singular?
let det = matrix.determinant  // 10.0 — non-zero, good

// Step 2: Is it numerically stable?
let cond = matrix.conditionNumber  // small value — safe to invert

// Step 3: For large matrices, use log form to avoid overflow
let ld = matrix.logDeterminant
// ld.sign = 1.0, ld.logAbsValue ≈ 2.302

// All checks pass — safe to proceed
let inverse = matrix.inverted()
```

For matrices that fail these diagnostics, we know to handle the situation gracefully — whether that means applying regularization, using a pseudoinverse, or simply reporting that the computation cannot be performed reliably.

## See also

- <doc:Matrices-Operations> - Matrix arithmetic, transpose, and multiplication
- <doc:Fundamentals> - Matrix-vector transformations and basis vectors
- <doc:Composition> - Composing multiple transformations
- <doc:Primer> - Linear algebra fundamentals
