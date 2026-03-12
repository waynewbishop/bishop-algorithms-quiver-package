# Linear Regression

Train an ordinary least squares regression model.

## Overview

Linear regression finds the best-fit line (or hyperplane) through training data by minimizing the sum of squared residuals. Unlike classification models that predict discrete categories, regression models predict continuous values — prices, temperatures, scores, or any numerical quantity.

### How it works

Linear regression models the relationship between features and a target as a linear equation: ŷ = θ₀ + θ₁x₁ + θ₂x₂ + ... + θₙxₙ. The goal is to find the coefficients θ that minimize the total squared error between predicted and actual values.

Quiver solves this using the **normal equation** θ = (X'X)⁻¹X'y, which gives an exact closed-form solution. This approach uses the matrix operations already available in Quiver — transposition, multiplication, and inversion — rather than iterative gradient descent. The result is a precise answer computed in a single pass.

### Fitting a model

The `fit(features:targets:intercept:)` static method computes the optimal coefficients and returns a ready-to-use model. There is no separate unfitted state — the returned struct is immediately usable.

> Tip: Regression models predict continuous `Double` values, so targets are `[Double]`. To predict discrete categories like "approved" or "denied", use a classification model instead. See <doc:Machine-Learning-Primer> for more on the distinction.

```swift
import Quiver

// Training data: square footage → price
let features: [[Double]] = [
    [1000], [1500], [2000], [2500], [3000]
]
let targets = [150000.0, 200000.0, 260000.0, 310000.0, 370000.0]

let model = try LinearRegression.fit(features: features, targets: targets)

// Inspect the coefficients
print("Intercept: \(model.coefficients[0])")   // bias term
print("Slope: \(model.coefficients[1])")        // price per sqft
```

### Making predictions

The `predict(_:)` method computes target values for new samples using the fitted coefficients:

```swift
import Quiver

let newHomes: [[Double]] = [[1800], [3500]]
let prices = model.predict(newHomes)
// prices ≈ [236000, 424000]
```

### Multiple features

Linear regression naturally extends to multiple features. Each feature gets its own coefficient weight:

```swift
import Quiver

// square footage, bedrooms, age
let features: [[Double]] = [
    [1200, 2, 20], [1800, 3, 10], [2400, 4, 5],
    [1600, 3, 15], [2000, 3, 8], [2800, 5, 2]
]
let targets = [180000.0, 260000.0, 350000.0,
               230000.0, 290000.0, 420000.0]

let model = try LinearRegression.fit(features: features, targets: targets)
print("Features: \(model.featureCount)")  // 3
```

### Evaluating the fit

Regression metrics tell us how well the model's predictions match the actual values. R² (coefficient of determination) measures the fraction of variance explained — 1.0 is perfect, 0.0 means the model is no better than predicting the mean:

```swift
import Quiver

let predictions = model.predict(features)

let r2   = predictions.rSquared(actual: targets)
let mse  = predictions.meanSquaredError(actual: targets)
let rmse = predictions.rootMeanSquaredError(actual: targets)

print("R²: \(r2)")      // closer to 1.0 is better
print("RMSE: \(rmse)")  // in the same units as the target
```

### The full pipeline

A typical workflow combines data splitting, model fitting, and evaluation:

```swift
import Quiver

// 20 houses: sqft, bedrooms
var features: [[Double]] = []
var targets: [Double] = []

for _ in 0..<20 {
    let sqft = Double.random(in: 800...3500)
    let beds = Double(Int.random(in: 1...5))
    features.append([sqft, beds])
    targets.append(50000 + 100 * sqft + 15000 * beds + Double.random(in: -10000...10000))
}

// Split
let (trainX, testX) = features.trainTestSplit(testRatio: 0.2, seed: 42)
let (trainY, testY) = targets.trainTestSplit(testRatio: 0.2, seed: 42)

// Fit and predict
let model = try LinearRegression.fit(features: trainX, targets: trainY)
let predictions = model.predict(testX)

// Evaluate
let r2 = predictions.rSquared(actual: testY)
let rmse = predictions.rootMeanSquaredError(actual: testY)
print("R²: \(r2), RMSE: \(rmse)")
```

### Organizing data with Panel

The same pipeline using `Panel` eliminates the need to split features and targets separately. One split keeps all columns aligned automatically:

```swift
import Quiver

let data = Panel([
    ("sqft", [1200.0, 1800.0, 2400.0, 1600.0, 2000.0,
              2800.0, 1400.0, 2200.0, 1000.0, 3000.0]),
    ("bedrooms", [2.0, 3.0, 4.0, 3.0, 3.0,
                  5.0, 2.0, 4.0, 2.0, 5.0]),
    ("price", [180000.0, 260000.0, 350000.0, 230000.0, 290000.0,
               420000.0, 195000.0, 320000.0, 160000.0, 450000.0])
])

// One split — features and targets stay aligned without matching seeds
let (train, test) = data.trainTestSplit(testRatio: 0.2, seed: 42)
let featureColumns = ["sqft", "bedrooms"]

// Fit, predict, evaluate
let model = try LinearRegression.fit(
    features: train.toMatrix(columns: featureColumns),
    targets: train["price"]
)
let predictions = model.predict(test.toMatrix(columns: featureColumns))
let r2 = predictions.rSquared(actual: test["price"])
print("R²: \(r2)")
```

`Panel` is entirely optional. The regression model accepts arrays directly, and developers who prefer working with raw arrays can continue to do so. See <doc:Panel> for details.

### When the normal equation fails

The normal equation requires inverting the matrix X'X. If the features are linearly dependent — for example, including both temperature in Celsius and Fahrenheit — the matrix is singular and cannot be inverted. In this case, `fit` throws `MatrixError.singular`. The fix is to remove redundant features before fitting.

### Safe by design

`LinearRegression` follows the same immutable-struct pattern as `GaussianNaiveBayes`. The model is always ready to use after `fit`, training data stays separate from test data, and reproducible splits ensure consistent results.

## Topics

### Model
- ``LinearRegression``

### Training
- ``LinearRegression/fit(features:targets:intercept:)``

### Prediction
- ``LinearRegression/predict(_:)``

### Evaluation
- ``Swift/Array/rSquared(actual:)``
- ``Swift/Array/meanSquaredError(actual:)``
- ``Swift/Array/rootMeanSquaredError(actual:)``

### Related
- <doc:Machine-Learning-Primer>
- <doc:Naive-Bayes>
