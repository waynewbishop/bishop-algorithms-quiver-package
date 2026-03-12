# Panel

A Quiver type that organizes named columns of numeric data into a single container.

## Overview

When working with multi-feature datasets, raw arrays require the developer to track which column is which by position alone. A feature matrix like `[[619, 15000, 0.08], [502, 78000, 0.04]]` offers no indication of what each column represents, and splitting or filtering requires careful coordination across parallel arrays to keep rows aligned.

Quiver's `Panel` type solves this by giving names to columns of `[Double]` data while keeping rows together as a unit. Developers familiar with Python's pandas `DataFrame` will recognize the concept — Panel serves a similar role for labeled columnar data, scoped to Quiver's numeric focus.

> Important: Panel does not replace Quiver's array and matrix operations — it organizes them. Each column is a standard `[Double]` that supports all existing Quiver vector operations like `.mean()`, `.std()`, `.standardized()`, and boolean masking.

### Creating a panel

Build a panel from an ordered list of named columns. All columns must have the same number of elements:

```swift
import Quiver

let data = Panel([
    ("age", [25.0, 30.0, 35.0, 28.0]),
    ("income", [50000.0, 60000.0, 75000.0, 55000.0]),
    ("score", [0.8, 0.6, 0.9, 0.7])
])
```

Panels can also be created from a matrix with column names, which is useful when labeling the output of a matrix operation:

```swift
import Quiver

let matrix: [[Double]] = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]]
let data = Panel(matrix: matrix, columns: ["x", "y"])
```

### Column access

Access any column by name with subscript syntax. The returned array is a standard `[Double]`, so all Quiver vector operations work immediately:

```swift
import Quiver

let data = Panel([
    ("age", [25.0, 30.0, 35.0, 28.0]),
    ("income", [50000.0, 60000.0, 75000.0, 55000.0])
])

data["income"].mean()          // 60000.0
data["age"].std()              // standard deviation
data["income"].standardized()  // z-scores
```

### Extracting matrices

Convert selected columns into a matrix for classifiers, feature scaling, or linear algebra. Columns appear in the order specified:

```swift
import Quiver

let data = Panel([
    ("a", [1.0, 4.0]),
    ("b", [2.0, 5.0]),
    ("c", [3.0, 6.0])
])

let all = data.toMatrix()                    // [[1, 2, 3], [4, 5, 6]]
let selected = data.toMatrix(columns: ["c", "a"])  // [[3, 1], [6, 4]]
```

### Filtering with boolean masks

Combine `Panel` with Quiver's boolean comparison operations to filter rows across all columns simultaneously:

```swift
import Quiver

let data = Panel([
    ("value", [10.0, 20.0, 30.0, 40.0]),
    ("label", [0.0, 1.0, 0.0, 1.0])
])

let mask = data["value"].isGreaterThan(15.0)
let filtered = data.filtered(where: mask)
// filtered["value"] == [20.0, 30.0, 40.0]
// filtered["label"] == [1.0, 0.0, 1.0]
```

### Splitting for machine learning

Split a panel into training and testing subsets with a single call. All columns are split atomically — the same rows go to training and testing across every column:

```swift
import Quiver

let data = Panel([
    ("feature1", [1.0, 2.0, 3.0, 4.0, 5.0,
                  6.0, 7.0, 8.0, 9.0, 10.0]),
    ("feature2", [10.0, 20.0, 30.0, 40.0, 50.0,
                  60.0, 70.0, 80.0, 90.0, 100.0]),
    ("label", [0.0, 1.0, 0.0, 1.0, 0.0,
               1.0, 0.0, 1.0, 0.0, 1.0])
])

let (train, test) = data.trainTestSplit(testRatio: 0.2, seed: 42)
let trainFeatures = train.toMatrix(columns: ["feature1", "feature2"])
let trainLabels = train["label"].map { Int($0) }
```

This eliminates the need to match seeds across parallel array splits, which is error-prone and a common source of row misalignment bugs.

### Descriptive statistics

Call `describe()` to get a quick overview of every column:

```swift
import Quiver

let data = Panel([
    ("age", [25.0, 30.0, 35.0, 28.0]),
    ("income", [50000.0, 60000.0, 75000.0, 55000.0])
])

print(data.describe())
// column          count       mean        std        min        max
// ----------------------------------------------------------------------
// age             4    29.5    3.6968    25.0    35.0
// income          4    60000.0    9128.7093    50000.0    75000.0
```

### Classification pipeline

Panel integrates directly with Quiver's classification workflow. A typical pipeline scales features, fits a classifier on training data, and evaluates predictions — all while keeping columns aligned:

```swift
import Quiver

let data = Panel([
    ("creditScore", [720.0, 650.0, 580.0, 710.0, 690.0,
                     620.0, 750.0, 600.0, 680.0, 640.0]),
    ("balance", [15000.0, 78000.0, 42000.0, 8000.0, 55000.0,
                 91000.0, 12000.0, 63000.0, 37000.0, 84000.0]),
    ("approved", [1.0, 0.0, 0.0, 1.0, 1.0,
                  0.0, 1.0, 0.0, 1.0, 0.0])
])

// Split preserves row alignment across all columns
let (train, test) = data.trainTestSplit(testRatio: 0.2, seed: 42)

// Scale features using training data only (prevents data leakage)
let scaler = FeatureScaler.fit(train.toMatrix(columns: ["creditScore", "balance"]))
let trainScaled = scaler.transform(train.toMatrix(columns: ["creditScore", "balance"]))
let testScaled = scaler.transform(test.toMatrix(columns: ["creditScore", "balance"]))

// Fit and evaluate
let trainLabels = train["approved"].map { Int($0) }
let testLabels = test["approved"].map { Int($0) }
let model = GaussianNaiveBayes.fit(features: trainScaled, labels: trainLabels)
let predictions = model.predict(testScaled)
```

### Design scope

Panel is intentionally focused on numeric columnar data for ML workflows. It is a value type with a fixed schema — columns cannot be added or removed after creation, and all values are `Double`. Panel does not support missing values, string columns, or groupBy aggregation. For those needs, consider a dedicated DataFrame library. Panel's strength is keeping labeled numeric data aligned through splits, filters, and matrix conversions without the overhead of a general-purpose data frame.

## Topics

### Panel
- ``Panel``
