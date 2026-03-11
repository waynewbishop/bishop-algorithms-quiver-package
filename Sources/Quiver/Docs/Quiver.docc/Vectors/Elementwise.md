# Element-wise Math

Apply standard mathematical functions to every element of an array in a single call.

## Overview

Quiver extends Swift arrays with element-wise versions of common mathematical functions. Each method applies the corresponding Foundation function to every element and returns a new array of the same length. These operations mirror the NumPy pattern of vectorized math, making it natural to express formulas that operate on entire datasets at once.

> Tip: Element-wise operations are available for both `Double` and `Float` arrays, matching their Foundation counterparts (`sin`/`sinf`, `log`/`logf`, etc.).

### Trigonometric functions

Compute sine, cosine, and tangent for every element in an array. Input values are in radians:

```swift
import Quiver

let angles = [0.0, .pi / 6, .pi / 4, .pi / 3, .pi / 2]

let sines   = angles.sin()   // [0.0, 0.5, 0.707, 0.866, 1.0]
let cosines = angles.cos()   // [1.0, 0.866, 0.707, 0.5, 0.0]
let tangents = angles.tan()  // [0.0, 0.577, 1.0, 1.732, ∞]
```

These are useful for generating waveforms, computing signal components, and working with angular data in physics or graphics applications.

### Logarithmic and exponential functions

Apply natural logarithm, base-10 logarithm, and exponential functions element-wise:

```swift
import Quiver

let values = [1.0, 10.0, 100.0, 1000.0]

let natural = values.log()    // [0.0, 2.302, 4.605, 6.908]
let base10  = values.log10()  // [0.0, 1.0, 2.0, 3.0]

let exponents = [0.0, 1.0, 2.0, 3.0]
let result = exponents.exp()  // [1.0, 2.718, 7.389, 20.086]
```

Logarithmic scaling is essential for working with data that spans multiple orders of magnitude — stock prices, earthquake measurements, sound levels, and probability distributions all benefit from log-space operations.

### Power and root functions

Raise elements to a power, compute squares, and extract square roots:

```swift
import Quiver

let data = [1.0, 4.0, 9.0, 16.0, 25.0]

let roots   = data.sqrt()      // [1.0, 2.0, 3.0, 4.0, 5.0]
let squares = data.square()    // [1.0, 16.0, 81.0, 256.0, 625.0]
let cubed   = data.power(3.0)  // [1.0, 64.0, 729.0, 4096.0, 15625.0]
```

The `power(_:)` method accepts any exponent, including fractional values like `0.5` (equivalent to `sqrt`) and negative values for reciprocals.

### Rounding functions

Round elements toward specific boundaries:

```swift
import Quiver

let measurements = [2.3, 3.7, -1.5, 4.1, -0.8]

let floored = measurements.floor()  // [2.0, 3.0, -2.0, 4.0, -1.0]
let ceiled  = measurements.ceil()   // [3.0, 4.0, -1.0, 5.0, 0.0]
let rounded = measurements.round()  // [2.0, 4.0, -2.0, 4.0, -1.0]
```

Rounding is useful for binning continuous data, aligning values to grid points, and preparing data for integer-based operations.

### Chaining operations

Element-wise functions return arrays, so they chain naturally with other Quiver operations:

```swift
import Quiver

let signal = [0.1, 0.5, 1.0, 2.0, 5.0]

// Log-transform, then standardize
let logScaled = signal.log().standardized()

// Compute RMS (root mean square)
let rms = signal.square().mean().map { $0.squareRoot() }
```

## Topics

### Trigonometric
- ``Swift/Array/sin()``
- ``Swift/Array/cos()``
- ``Swift/Array/tan()``

### Logarithmic and exponential
- ``Swift/Array/log()``
- ``Swift/Array/log10()``
- ``Swift/Array/exp()``

### Power and roots
- ``Swift/Array/power(_:)``
- ``Swift/Array/sqrt()``
- ``Swift/Array/square()``

### Rounding
- ``Swift/Array/floor()``
- ``Swift/Array/ceil()``
- ``Swift/Array/round()``

### Related articles
- <doc:Elements>
- <doc:Operations>
- <doc:Statistics>
