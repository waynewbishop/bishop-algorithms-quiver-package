# Usage

Explore Quiver interactively using the Xcode Playground macro.

## Overview

Quiver is a Swift package for numerical computing — vectors, matrices, statistics, and machine learning. Like NumPy or scikit-learn in the Python ecosystem, Quiver is a library that ships in production apps and services. It runs on every Apple platform, on Linux, and in server-side frameworks like Vapor. Developers add it to real projects and deploy it to real users.

But production code is only half the story. Interactive environments — where we write a line of code, see the result immediately, and build intuition one expression at a time — are essential for education and experimentation. The `#Playground` macro, introduced in **Xcode 26**, brings that interactive workflow to any Swift project — including projects that depend on Quiver.

A playground is a space for exploration. We write an expression, and the Canvas shows the result inline — no build-and-run cycle, no `print` statements, no separate output window. For a library like Quiver, this means we can compute a dot product, inspect a matrix inverse, or fit a regression model and see every intermediate value as we type. It is the fastest way to learn what an operation does, verify that the math is correct, or prototype an idea before committing to an implementation.

> Tip: The `#Playground` macro is not the same as a `.playground` file. Traditional `.playground` files run in an isolated sandbox and cannot import Swift packages. The `#Playground` macro compiles as part of the project, so it has full access to SPM dependencies — including Quiver — with no extra configuration.

### Writing your first playground

Add a new Swift file to any project that already depends on Quiver, import `Playgrounds`, and wrap the code in a `#Playground` block:

```swift
import Playgrounds
import Quiver

#Playground {
    // Create a 2D vector
    let v = [3.0, 4.0]

    // Compute the length using the Pythagorean theorem: sqrt(3² + 4²)
    v.magnitude  // 5.0

    // Get the unit vector — same direction, length of 1
    v.normalized  // [0.6, 0.8]

    // Display the unit vector as exact fractions
    v.normalized.asFractions()  // [3/5, 4/5]
}
```

The `magnitude` property measures how long the vector is — the distance from the origin to the point `[3, 4]`. The `normalized` property divides each element by that magnitude, producing a unit vector that preserves direction but has a length of exactly 1. The `asFractions()` method shows the result as rational numbers, which is useful for verifying exact values.

Open the Canvas to see the result of every expression, updated live as we type. Each line produces inline output — no `print` statements needed.

### Multiple experiments in one file

Name the playground blocks to organize experiments. Each block runs independently:

```swift
import Playgrounds
import Quiver

#Playground("Dot Product") {
    let a = [1.0, 2.0, 3.0]
    let b = [4.0, 5.0, 6.0]

    // Sum of element-wise products: (1×4) + (2×5) + (3×6)
    a.dot(b)  // 32.0
}

#Playground("Cosine Similarity") {
    let query = [0.8, 0.7, 0.2]
    let doc = [0.7, 0.6, 0.3]

    // Measures directional alignment, ignoring magnitude (1.0 = identical)
    query.cosineOfAngle(with: doc)  // 0.98
}
```

The dot product multiplies corresponding elements and sums the results. It is the foundation of most similarity and projection operations. Cosine similarity normalizes that dot product by both vectors' magnitudes, producing a value between -1 and 1 that measures how closely two vectors point in the same direction — regardless of their length.

Named blocks are useful for comparing related operations side by side or working through a series of exercises in a single file.

### Inspecting results

The Canvas shows the value of each expression as we write it. For arrays and matrices, this makes it easy to verify intermediate steps:

```swift
import Playgrounds
import Quiver

#Playground("Matrix Operations") {
    let A = [[1.0, 2.0], [3.0, 4.0]]
    let B = [[5.0, 6.0], [7.0, 8.0]]

    // Each element in the result is a dot product of a row from A and a column from B
    A.matrixMultiply(B)  // [[19.0, 22.0], [43.0, 50.0]]

    // Swap rows and columns — row 0 becomes column 0
    A.transpose()  // [[1.0, 3.0], [2.0, 4.0]]

    // The determinant measures how much a matrix scales area (zero means singular)
    A.determinant()  // -2.0
}
```

Matrix multiplication combines two matrices by computing dot products between rows and columns. The transpose flips a matrix along its diagonal, turning rows into columns. The determinant is a single number that captures whether a matrix is invertible — a zero determinant means the matrix collapses space into a lower dimension and cannot be inverted. These three operations are the building blocks for solving systems of equations, fitting regression models, and applying geometric transformations.

### Iterating on code

The `#Playground` macro re-evaluates automatically when we edit. This makes it ideal for experimenting with different parameters — adjusting feature ranges, changing scaling strategies, or comparing normalization approaches — and seeing the effect immediately.

```swift
import Playgrounds
import Quiver

#Playground("Feature Scaling") {
    let raw = [100.0, 200.0, 300.0, 400.0, 500.0]

    // Rescale to [0, 1] based on min and max values
    let minMax = raw.minMaxScaled()
    minMax  // [0.0, 0.25, 0.5, 0.75, 1.0]

    // Center around zero with unit standard deviation
    let zScore = raw.zScoreScaled()
    zScore  // [-1.41, -0.71, 0.0, 0.71, 1.41]
}
```

Min-max scaling compresses values into the range [0, 1] by subtracting the minimum and dividing by the range. Z-score scaling subtracts the mean and divides by the standard deviation, centering the data at zero. Both approaches are essential preprocessing steps before training machine learning models, because features on different scales can bias algorithms that rely on distance measurements.
