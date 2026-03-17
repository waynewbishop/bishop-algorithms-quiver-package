# Quiver — Swift Numerical Computing Library

Complete reference for the Quiver Swift package. Upload this file to a Claude Project or conversation to get accurate assistance with Quiver code.

**Repository:** https://github.com/waynewbishop/quiver
**Module:** `import Quiver`
**Platforms:** macOS 12+, iOS 15+, tvOS 15+, watchOS 8+, visionOS 1+
**Swift:** 5.9+
**Dependencies:** None (pure Swift)

---

## How Quiver Works

Quiver extends Swift's `Array` type with numerical computing methods. There are no custom container types — everything operates on `[Double]`, `[[Double]]`, `[Int]`, `[Bool]`, and `[String]`. This means every Quiver array inherits Swift's full standard library (`map`, `filter`, `sorted`, `reduce`, `enumerated`, `zip`, etc.) for free.

Internal logic lives in `_Vector` types that are not part of the public API. The public surface is clean Array extensions constrained by `Numeric`, `FloatingPoint`, `Comparable`, or `BinaryFloatingPoint`.

ML models are immutable value types created via static `fit()` methods. There is no unfitted state — you cannot call `predict()` on a model that hasn't been trained.

---

## Vector Arithmetic

Element-wise operations use **named methods**, not operators:

```swift
let a = [1.0, 2.0, 3.0]
let b = [4.0, 5.0, 6.0]

a.add(b)        // [5.0, 7.0, 9.0]
a.subtract(b)   // [-3.0, -3.0, -3.0]
a.multiply(b)   // [4.0, 10.0, 18.0]
a.divide(b)     // [0.25, 0.4, 0.5]
```

**Scalar broadcast operators** are supported:

```swift
2.0 + a    // [3.0, 4.0, 5.0]
a - 1.0    // [0.0, 1.0, 2.0]
3.0 * a    // [3.0, 6.0, 9.0]
a / 2.0    // [0.5, 1.0, 1.5]
```

**Important:** `a + b` where both are arrays will NOT compile. Use `.add()`. Scalar broadcast (`a + 2.0`) works fine.

## Matrix Arithmetic

Same pattern — named methods for matrix-matrix, operators for scalar:

```swift
let A = [[1.0, 2.0], [3.0, 4.0]]
let B = [[5.0, 6.0], [7.0, 8.0]]

A.add(B)        // element-wise add
A.subtract(B)   // element-wise subtract
A.multiply(B)   // Hadamard product (element-wise)
A.divide(B)     // element-wise divide

A + 10.0        // scalar broadcast (works)
2.0 * A         // scalar broadcast (works)
```

## Dot Product and Projections

All on `[FloatingPoint]`, all return non-optional values:

```swift
let a = [1.0, 2.0, 3.0]
let b = [4.0, 5.0, 6.0]

a.dot(b)                        // 32.0
a.scalarProjection(onto: b)     // projection length
a.vectorProjection(onto: b)     // vector component in direction of b
a.orthogonalComponent(to: b)    // perpendicular remainder
```

## Magnitude and Distance

```swift
let v = [3.0, 4.0]
v.magnitude          // 5.0 (non-optional)
v.normalized         // [0.6, 0.8] (non-optional)
v.distance(to: w)    // Euclidean distance (non-optional)
```

## Angular Operations

```swift
a.cosineOfAngle(with: b)    // cosine similarity [-1, 1] (non-optional)
a.angle(with: b)             // angle in radians (non-optional)
a.angleInDegrees(with: b)    // angle in degrees (non-optional)
```

## Matrix Transformations

```swift
let M = [[1.0, 2.0], [3.0, 4.0]]
let v = [1.0, 0.0]

M.transform(v)              // matrix-vector multiply (non-optional)
M.transpose()                // swap rows and columns (non-optional)
M.transposed()               // same as transpose()
M.multiplyMatrix(other)      // matrix-matrix multiply (non-optional)
M.column(at: 0)              // extract column vector (non-optional)

M.determinant                // determinant value (non-optional)
M.conditionNumber            // condition number, 1-norm (non-optional)
M.logDeterminant             // LogDeterminant struct (non-optional)
  // .sign (-1, 0, or 1)
  // .logAbsValue
  // .value (reconstructed)

try M.inverted()             // matrix inverse (throws MatrixError)
```

`MatrixError` cases: `.notSquare`, `.singular`

## Shape and Reshape

```swift
let M = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
M.shape          // (rows: 2, columns: 3) (non-optional)
M.size           // 6 (non-optional)
M.flattened()    // [1, 2, 3, 4, 5, 6] (non-optional)

let flat = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
flat.reshaped(rows: 2, columns: 3)   // back to 2x3 (non-optional)
```

## Array Generation

All called on `[Double]` (not `[[Double]]`), even for 2D:

```swift
// 1D
[Double].zeros(5)
[Double].ones(5)
[Double].full(5, value: 3.14)

// 2D — note: called on [Double], returns [[Double]]
[Double].zeros(2, 3)
[Double].ones(2, 3)
[Double].full(2, 3, value: 7.0)

// Special matrices
[Double].identity(3)           // 3x3 identity
[Double].diag([1.0, 2.0, 3.0]) // diagonal matrix

// Sequences
[Double].linspace(start: 0.0, end: 1.0, count: 5)   // [0.0, 0.25, 0.5, 0.75, 1.0]
[Double].arange(0.0, 10.0, step: 2.5)                // [0.0, 2.5, 5.0, 7.5]
```

## Random Generation

```swift
// Uniform
[Double].random(5)                      // 1D, [0, 1]
[Double].random(2, 3)                   // 2D, [0, 1]
[Double].random(5, in: 10.0...20.0)     // custom range
[Double].random(2, 3, in: -1.0...1.0)   // 2D custom range
[Int].random(5, in: 0..<100)            // Int, half-open range

// Normal distribution
[Double].randomNormal(5, mean: 0.0, std: 1.0)
[Double].randomNormal(2, 3, mean: 5.0, std: 2.0)
```

## Statistical Operations

### Return optionals (must unwrap):

```swift
let data = [3.0, 1.0, 4.0, 1.0, 5.0]

if let avg = data.mean() { print(avg) }           // Double?
if let mid = data.median() { print(mid) }         // Double?
if let v = data.variance(ddof: 0) { print(v) }    // Double? (population)
if let s = data.std(ddof: 1) { print(s) }         // Double? (sample)
if let q = data.quartiles() { print(q.iqr) }      // tuple?
if let lo = data.argMin() { print(lo) }            // Int?
if let hi = data.argMax() { print(hi) }            // Int?
if let p = data.percentile(90) { print(p) }        // Double?
```

### Return non-optional:

```swift
data.sum()                // Double
data.product()            // Double
data.cumulativeSum()      // [Double]
data.cumulativeProduct()  // [Double]
data.percentileRank(of: 3.0)  // Double
data.percentileRanks()        // [Double]
data.histogram(bins: 6)       // [(midpoint: Double, count: Int)]
data.outlierMask(threshold: 2.0)  // [Bool]
```

### Multi-vector (return optionals):

```swift
let vectors: [[Double]] = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
if let mv = vectors.meanVector() { print(mv) }   // [Double]?
if let avg = vectors.averaged() { print(avg) }   // [Double]?
```

## Similarity and Clustering

```swift
let docs: [[Double]] = [...]
let query = [1.0, 0.0, 1.0]

docs.cosineSimilarities(to: query)      // [Double] (non-optional)
docs.findDuplicates(threshold: 0.9)     // [(index1, index2, similarity)]
docs.clusterCohesion()                  // Double
```

## Ranking and Sorting

```swift
let scores = [0.9, 0.1, 0.7, 0.3, 0.5]

scores.topIndices(k: 3)                                         // [(index, score)]
scores.topIndices(k: 2, labels: ["A", "B", "C", "D", "E"])    // [(label, score)]
scores.sortedIndices()                                          // [Int] (argsort)
```

## Broadcasting

### Scalar (named methods):

```swift
data.broadcast(adding: 10.0)
data.broadcast(subtracting: 1.0)
data.broadcast(multiplyingBy: 2.0)
data.broadcast(dividingBy: 3.0)
data.broadcast(with: 2.0, operation: { $0 + $1 })
```

### Matrix (row/column vector):

```swift
matrix.broadcast(addingToEachRow: rowVec)
matrix.broadcast(addingToEachColumn: colVec)
matrix.broadcast(multiplyingEachRowBy: rowVec)
matrix.broadcast(multiplyingEachColumnBy: colVec)
matrix.broadcast(withRowVector: rowVec, operation: +)
matrix.broadcast(withColumnVector: colVec, operation: *)
```

## Boolean and Comparison

### Comparison (returns `[Bool]`):

```swift
data.isGreaterThan(3.0)
data.isLessThan(3.0)
data.isGreaterThanOrEqual(3.0)
data.isLessThanOrEqual(3.0)
data.isEqual(to: otherArray)    // takes an array, not a scalar
```

### Boolean operations:

```swift
mask1.and(mask2)       // element-wise AND
mask1.or(mask2)        // element-wise OR
mask1.not              // element-wise NOT (computed property)
mask1.trueIndices      // [Int] — indices where true
```

### Boolean indexing:

```swift
data.masked(by: mask)                          // select where true
data.choose(where: mask, otherwise: otherArray) // conditional (takes array, not scalar)
```

## Element-wise Math

Available on `[Double]` and `[Float]`:

```swift
vals.power(2.0)    // raise to power
vals.sqrt()        // square root
vals.square()      // x^2
vals.log()         // natural log
vals.log10()       // base-10 log
vals.exp()         // e^x
vals.sin()         // sine
vals.cos()         // cosine
vals.tan()         // tangent
vals.floor()       // round down
vals.ceil()        // round up
vals.round()       // round to nearest
```

### Activation Functions:

```swift
logits.softMax()    // probability distribution summing to 1.0
logits.sigmoid()    // element-wise 1/(1+e^-x), each in (0,1)
```

## Time Series

```swift
series.rollingMean(window: 3)
series.diff(lag: 1)
series.percentChange(lag: 1)
```

## Data Visualization Helpers

```swift
// Scaling
revenues.scaled(to: 10.0...50.0)    // min-max to range
revenues.standardized()               // z-score (mean=0, std=1)
revenues.asPercentages()              // share of total

// Aggregation
sales.groupBy(regions, using: .sum)            // [String: Double]
sales.groupedData(by: regions, using: .mean)   // [(category, value)]
data.downsample(factor: 6, using: .mean)       // reduce resolution
// AggregationMethod: .sum, .mean, .count, .min, .max

// Multi-series
series.stackedCumulative()     // for stacked area charts
series.stackedPercentage()     // for 100% stacked bars
vectors.correlationMatrix()    // Pearson correlation matrix
vectors.heatmapData(labels:)   // [(x, y, value)] for RectangleMark
```

## Text Operations

```swift
"Hello World! This is a test.".tokenize()   // ["hello", "world", "this", "is", "a", "test"]

let embeddings: [String: [Double]] = ["hello": [0.1, 0.2], ...]
tokens.embed(using: embeddings)   // [[Double]] — vectors for known words
```

## Fraction Type

```swift
let frac = Fraction(numerator: 3, denominator: 4)
frac.value          // 0.75
frac.description    // "3/4"

Fraction(0.333)              // auto-detect: 333/1000 or similar
0.75.asFraction()            // Fraction
[0.5, 0.25].asFractions()   // [Fraction]
[[0.5, 0.25]].asFractions()  // [[Fraction]]
```

## Info and Debugging

```swift
[1.0, 2.0, 3.0].info()             // pretty-printed stats
[[1.0, 2.0], [3.0, 4.0]].info()    // matrix info with shape
```

## Sampling and Splitting

```swift
// Basic split — use matching seeds for paired arrays
let (trainX, testX) = features.trainTestSplit(testRatio: 0.2, seed: 42)
let (trainY, testY) = labels.trainTestSplit(testRatio: 0.2, seed: 42)

// Stratified split — preserves class proportions
let (trainF, testF, trainL, testL) = features.stratifiedSplit(
    labels: labels, testRatio: 0.2, seed: 42
)
```

## Feature Scaling

```swift
let scaler = FeatureScaler.fit(features: trainX, range: 0.0...1.0)
let scaledTrain = scaler.transform(trainX)
let scaledTest = scaler.transform(testX)

scaler.minimums      // [Double]
scaler.maximums      // [Double]
scaler.range         // ClosedRange<Double>
scaler.featureCount  // Int
```

## Classification Metrics

```swift
let cm = predictions.confusionMatrix(actual: truth)
cm.truePositives     // Int
cm.falsePositives    // Int
cm.trueNegatives     // Int
cm.falseNegatives    // Int
cm.accuracy          // Double (non-optional)
cm.precision         // Double? (nil if TP+FP == 0)
cm.recall            // Double? (nil if TP+FN == 0)
cm.f1Score           // Double? (nil if precision or recall is nil)

// Standalone
predictions.accuracy(actual: truth)    // Double
predictions.precision(actual: truth)   // Double?
predictions.recall(actual: truth)      // Double?
predictions.f1Score(actual: truth)     // Double?
```

## Regression Metrics

```swift
predicted.rSquared(actual: actual)              // Double (non-optional)
predicted.meanSquaredError(actual: actual)       // Double (non-optional)
predicted.rootMeanSquaredError(actual: actual)   // Double (non-optional)
```

## Linear Regression

```swift
let model = try LinearRegression.fit(features: trainX, targets: trainY)
// throws MatrixError.singular if features are linearly dependent

model.coefficients    // [Double] — [intercept, weight1, weight2, ...]
model.featureCount    // Int
model.hasIntercept    // Bool

let predictions = model.predict(testX)          // [[Double]] → [Double]
let singleFeature = model.predict(xValues)      // [Double] → [Double] (featureCount == 1)
```

## K-Means Clustering

```swift
let km = KMeans.fit(data: features, k: 3, seed: 42)
km.centroids     // [[Double]]
km.labels        // [Int]
km.inertia       // Double
km.iterations    // Int
km.featureCount  // Int
km.predict(newData)  // [Int]

// Best of multiple runs
let best = KMeans.bestFit(data: features, k: 3, attempts: 10)

// Elbow method
let inertias = KMeans.elbowMethod(data: features, kRange: Array(1...8), seed: 42)
```

## K-Nearest Neighbors

```swift
let knn = KNearestNeighbors.fit(
    features: trainX, labels: trainY,
    k: 3, metric: .euclidean, weight: .uniform
)
// DistanceMetric: .euclidean, .cosine
// VoteWeight: .uniform, .distance

knn.predict(testX)   // [Int]
knn.k                // Int
knn.metric           // DistanceMetric
knn.featureCount     // Int
```

## Gaussian Naive Bayes

```swift
let gnb = GaussianNaiveBayes.fit(features: trainX, labels: trainY)
gnb.predict(testX)                    // [Int]
gnb.predictLogProbabilities(testX)    // [[Double]]
gnb.featureCount                      // Int
gnb.classes                           // [ClassStats]
  // .label: Int, .prior: Double, .means: [Double], .variances: [Double], .count: Int
```

## Panel (Columnar Data)

```swift
// Create
let panel = Panel([("age", [25.0, 30.0, 35.0]), ("salary", [50000.0, 60000.0, 70000.0])])
let panel2 = Panel(["age": [25.0, 30.0], "salary": [50000.0, 60000.0]])
let panel3 = Panel(matrix: [[25.0, 50000.0], [30.0, 60000.0]], columns: ["age", "salary"])

// Access
panel["age"]              // [Double]
panel.labels("age")       // [Int]
panel.columnNames         // [String]
panel.rowCount            // Int
panel.toMatrix()          // [[Double]]

// Filter and split
panel.filtered(where: [true, false, true])
let (train, test) = panel.trainTestSplit(testRatio: 0.2, seed: 42)

// Summary statistics
panel.describe()   // String
```

---

## Common Patterns

### Full ML pipeline

```swift
import Quiver

// Load data
let panel = Panel([("f1", features1), ("f2", features2), ("label", labels)])
let features = panel.toMatrix(columns: ["f1", "f2"])
let labels = panel.labels("label")

// Split
let (trainF, testF, trainL, testL) = features.stratifiedSplit(
    labels: labels, testRatio: 0.2, seed: 42
)

// Scale
let scaler = FeatureScaler.fit(features: trainF)
let scaledTrain = scaler.transform(trainF)
let scaledTest = scaler.transform(testF)

// Train
let model = GaussianNaiveBayes.fit(features: scaledTrain, labels: trainL)

// Evaluate
let predictions = model.predict(scaledTest)
let cm = predictions.confusionMatrix(actual: testL)
print(cm.accuracy)
```

### Semantic search

```swift
import Quiver

let query = "running shoes".tokenize()
let embeddings: [String: [Double]] = [...]   // pre-trained word vectors
if let queryVector = query.embed(using: embeddings).meanVector() {
    let results = documents.cosineSimilarities(to: queryVector)
    let top3 = results.topIndices(k: 3, labels: docNames)
    print(top3)
}
```

### Data visualization pipeline (Quiver + Swift Charts)

```swift
import Quiver

let raw = [100.0, 200.0, 300.0, 400.0, 500.0]
let scaled = raw.scaled(to: 0.0...1.0)       // for chart sizing
let zScores = raw.standardized()               // for comparison overlay
let shares = raw.asPercentages()               // for pie/donut charts
let bins = raw.histogram(bins: 5)              // for bar charts
```

---

## Quick Reference: What Returns Optional?

| Returns Optional | Returns Non-Optional |
|---|---|
| `mean()` → `Double?` | `sum()` → `Double` |
| `median()` → `Double?` | `product()` → `Double` |
| `variance(ddof:)` → `Double?` | `magnitude` → `Double` |
| `std(ddof:)` → `Double?` | `normalized` → `[Double]` |
| `quartiles()` → tuple? | `dot(_:)` → `Double` |
| `argMin()` → `Int?` | `cosineOfAngle(with:)` → `Double` |
| `argMax()` → `Int?` | `determinant` → `Double` |
| `percentile(_:)` → `Double?` | `softMax()` → `[Double]` |
| `meanVector()` → `[Double]?` | `sigmoid()` → `[Double]` |
| `averaged()` → `[Double]?` | `scaled(to:)` → `[Double]` |
| `cm.precision` → `Double?` | `standardized()` → `[Double]` |
| `cm.recall` → `Double?` | `cm.accuracy` → `Double` |
| `cm.f1Score` → `Double?` | `rSquared(actual:)` → `Double` |
