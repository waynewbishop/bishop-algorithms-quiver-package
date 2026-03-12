# Data Visualization

Prepare, scale, and reshape data for Swift Charts and other visualization frameworks.

## Overview

Quiver provides a set of functions that bridge numerical data and chart-ready output. These operations handle the data preparation step — scaling values to a target range, computing frequency distributions, stacking series for area charts, and downsampling large datasets for responsive rendering. Each function returns structured output that maps directly to Swift Charts mark types.

### Scaling and normalization

Raw data often needs scaling before visualization. Quiver offers three approaches depending on the use case:

```swift
import Quiver

let revenues = [45000.0, 52000.0, 48000.0, 61000.0, 55000.0]

// Min-max scaling to a custom range (e.g., for sizing chart elements)
let sizes = revenues.scaled(to: 10.0...50.0)
// [10.0, 17.5, 13.75, 50.0, 32.5]

// Z-score standardization (mean=0, std=1) for comparing distributions
let standardized = revenues.standardized()
// [-1.38, -0.14, -0.85, 1.46, 0.92]

// Convert to percentages of total (for pie/donut charts)
let shares = revenues.asPercentages()
// [17.2, 19.9, 18.4, 23.4, 21.1]
```

Min-max scaling with `scaled(to:)` maps values to any closed range, which is useful for controlling the visual size of chart marks. Standardization with `standardized()` centers data around zero, making it possible to overlay series with different units on the same axis. Percentages with `asPercentages()` express each value as a share of the total, ready for proportional charts.

### Stacked series

Stacked area and bar charts require cumulative data where each series builds on the one below it. Quiver handles this transformation for both absolute and percentage-based stacking:

```swift
import Quiver

let mobile  = [120.0, 135.0, 150.0, 140.0]
let desktop = [200.0, 190.0, 210.0, 195.0]
let tablet  = [50.0, 55.0, 45.0, 60.0]

let series = [mobile, desktop, tablet]

// Cumulative stacking (each series adds to the previous)
let stacked = series.stackedCumulative()
// stacked[0] = [120.0, 135.0, 150.0, 140.0]     (mobile)
// stacked[1] = [320.0, 325.0, 360.0, 335.0]     (mobile + desktop)
// stacked[2] = [370.0, 380.0, 405.0, 395.0]     (all three)

// Percentage stacking (each time point sums to 100%)
let percents = series.stackedPercentage()
// percents[0] = [32.4, 35.5, 37.0, 35.4]   (mobile %)
// percents[1] = [54.1, 50.0, 51.9, 49.4]   (desktop %)
// percents[2] = [13.5, 14.5, 11.1, 15.2]   (tablet %)
```

### Correlation heatmaps

Visualize relationships between multiple variables using a correlation matrix flattened into chart-ready tuples:

```swift
import Quiver

let temperature = [30.0, 32.0, 35.0, 28.0, 33.0]
let iceCream    = [200.0, 220.0, 260.0, 180.0, 230.0]
let hotCocoa    = [150.0, 130.0, 100.0, 170.0, 120.0]

// Compute the correlation matrix
let matrix = [temperature, iceCream, hotCocoa].correlationMatrix()
// [[1.0,   0.99, -0.99],
//  [0.99,  1.0,  -0.98],
//  [-0.99, -0.98, 1.0]]

// Flatten to (x, y, value) tuples for heatmap rendering
let labels = ["Temp", "Ice Cream", "Hot Cocoa"]
let heatmap = [temperature, iceCream, hotCocoa].heatmapData(labels: labels)
// [("Temp", "Temp", 1.0), ("Temp", "Ice Cream", 0.99), ...]
```

Each tuple maps directly to a `RectangleMark` in Swift Charts, with the value driving color intensity.

### Downsampling

Large datasets can slow chart rendering. Downsampling reduces data volume while preserving the shape of the signal by aggregating values within fixed-size windows:

```swift
import Quiver

// Hourly readings over a day
let hourlyTemps = [
    18.0, 17.5, 17.0, 16.5, 16.0, 16.5,
    18.0, 20.0, 22.0, 24.0, 25.5, 26.0,
    27.0, 27.5, 27.0, 26.0, 24.5, 23.0,
    21.0, 19.5, 18.5, 18.0, 17.5, 17.0
]

// Reduce to 4 six-hour averages
let sixHourly = hourlyTemps.downsample(factor: 6, using: .mean)
// [17.6, 22.6, 26.5, 18.6]

// Keep the peak value in each window instead
let sixHourlyMax = hourlyTemps.downsample(factor: 6, using: .max)
// [18.0, 26.0, 27.5, 21.0]
```

The `AggregationMethod` parameter controls how values within each window are combined: `.mean` for smoothed trends, `.max` or `.min` for extremes, `.sum` for totals, and `.count` for frequency.

## Topics

### Scaling and normalization
- ``Swift/Array/scaled(to:)``
- ``Swift/Array/standardized()``
- ``Swift/Array/asPercentages()``

### Distribution analysis
- ``Swift/Array/histogram(bins:)``
- ``Swift/Array/quartiles()``
- ``Swift/Array/percentile(_:)``
- ``Swift/Array/percentileRank(of:)``
- ``Swift/Array/percentileRanks()``

### Multi-series operations
- ``Swift/Array/stackedCumulative()``
- ``Swift/Array/stackedPercentage()``
- ``Swift/Array/correlationMatrix()``
- ``Swift/Array/heatmapData(labels:)``

### Downsampling
- ``Swift/Array/downsample(factor:using:)``

### Grouping and aggregation
- ``Swift/Array/groupBy(_:using:)``
- ``Swift/Array/groupedData(by:using:)``
