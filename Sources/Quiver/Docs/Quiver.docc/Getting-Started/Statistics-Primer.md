# Statistics Primer

Transform raw data into actionable insights using statistical operations.

## Overview

iOS and macOS developers constantly work with data—user metrics, sensor readings, time-series measurements, and performance analytics. Statistics provides the tools to understand patterns, identify outliers, and make data-driven decisions. This primer teaches you practical statistical thinking using Quiver's operations.

## Understanding your data

Every dataset tells a story. Statistical measures help you listen to that story by answering fundamental questions about your data.

### Central tendency

Central tendency measures identify the "typical" or "middle" value in your data. These are the first questions to ask when exploring any dataset.

#### Mean (average)

The mean represents the balance point of your data:

```swift
let sessionDurations = [45.0, 120.0, 30.0, 90.0, 60.0, 75.0]
let average = sessionDurations.mean()  // 70.0 seconds

// Daily measurements
let dailyValues = [8500.0, 12000.0, 6500.0, 10000.0, 9200.0]
let avgValue = dailyValues.mean()  // 9240.0
```

**When to use mean:**
- Evenly distributed data without extreme outliers
- When you want the mathematical center of your data
- Calculating rates, averages, and expectations

#### Median (middle value)

The median is the middle value when data is sorted. Unlike mean, it's resistant to outliers:

```swift
let responseTimes = [0.5, 0.6, 0.7, 0.8, 15.0]  // One slow outlier
let avgTime = responseTimes.mean()    // 3.52 (skewed by outlier)
let medianTime = responseTimes.median()  // 0.7 (typical value)

// Duration data with outliers
let durations = [2.0, 3.0, 5.0, 4.0, 120.0]  // One unusually long duration
let typicalDuration = durations.median()  // 4.0 minutes
```

**When to use median:**
- Data with outliers (very high or low values)
- Skewed distributions
- When you want the "typical" user experience

> Important: If mean and median are very different, your data has outliers or is skewed.

### Dispersion

Dispersion measures tell you how spread out your data is. Two datasets can have the same mean but very different spreads.

#### Variance

Variance measures the average squared distance from the mean:

```swift
let measurements = [72.0, 68.0, 75.0, 71.0, 69.0, 73.0, 70.0]
let variance = measurements.variance()  // 4.98

// Low variance = consistent measurements
// High variance = variable measurements
```

#### Standard deviation

Standard deviation is the square root of variance, measured in the same units as your data:

```swift
let temperatures = [20.5, 21.0, 20.8, 20.6, 20.9]
let std = temperatures.std()  // 0.19°C

// Temperature stays within ±0.19°C of mean
// Indicates stable conditions
```

**Interpreting standard deviation:**
- Low std (relative to mean): Data is consistent
- High std (relative to mean): Data is variable
- For normal distributions: ~68% of data falls within ±1 std of mean

```swift
// Resource consumption analysis
let consumption = [15.0, 18.0, 16.0, 17.0, 19.0, 14.0, 16.0]  // units per hour
let avgConsumption = consumption.mean()  // 16.4
let consistency = consumption.std()  // 1.59

// Most values fall between 14.7 and 18.1 units per hour
```

## Common data patterns

### Time-series analysis

Track measurements over time and identify trends:

```swift
// Weekly measurements
let weeklyData = [68.0, 72.0, 70.0, 69.0, 71.0, 70.0, 73.0]

let baseline = weeklyData.mean()  // 70.4
let variability = weeklyData.std()  // 1.59

// Detect unusual readings (> 2 std from mean)
let threshold = baseline + (2.0 * variability)
let unusual = weeklyData.isGreaterThan(threshold)
```

### Smoothing noisy data

Reduce noise using moving averages:

```swift
// Raw sensor readings
let rawData = [0.12, 0.15, 0.11, 0.14, 0.13, 0.12, 0.16]

// Moving average smoothing
let windowSize = 3
let smoothed = stride(from: 0, to: rawData.count - windowSize + 1, by: 1)
    .map { start in
        Array(rawData[start..<start + windowSize]).mean() ?? 0.0
    }
// [0.127, 0.133, 0.127, 0.130, 0.137]
```

### User behavior analysis

Understand patterns through session metrics:

```swift
// Session durations in minutes
let sessions = [3.0, 15.0, 8.0, 5.0, 12.0, 180.0, 7.0, 10.0]

// Median gives typical session (not skewed by outlier)
let typical = sessions.median()  // 9.0 minutes

// Identify extreme values (> 2 std above mean)
guard let avg = sessions.mean(), let std = sessions.std() else { return }
let extremeThreshold = avg + (2.0 * std)
let extremeValues = sessions.isGreaterThan(extremeThreshold)
```

### Performance metrics

Track and validate system performance:

```swift
// Response times in milliseconds
let responseTimes = [120.0, 135.0, 128.0, 5000.0, 132.0, 125.0, 130.0]

// Detect outliers (> 3 std from mean)
let outliers = responseTimes.outlierMask(threshold: 3.0)
let validResponses = responseTimes.masked(by: outliers.not)

// Report typical performance
let p50 = validResponses.median()  // Median (50th percentile)
let avgResponse = validResponses.mean()  // Average
```

## Data quality and validation

### Outlier detection

Identify unusual values that may indicate errors or special cases:

```swift
// Daily sales data
let sales = [1200.0, 1350.0, 1280.0, 15000.0, 1310.0, 1290.0]

// Statistical outlier detection (z-score method)
let outlierMask = sales.outlierMask(threshold: 2.0)
// [false, false, false, true, false, false]

// Investigate the outlier
let outlierIndices = outlierMask.trueIndices  // [3]
let outlierValue = sales[3]  // 15000.0 - Black Friday sale?

// Clean data for typical analysis
let normalSales = sales.masked(by: outlierMask.not)
let typicalDaily = normalSales.mean()  // 1286.0
```

### Range validation

Ensure sensor data falls within expected ranges:

```swift
// Sensor readings with invalid values
let readings = [23.5, 24.1, -999.0, 23.8, 24.2, 150.0, 23.9]

// Valid range: 0-50
let valid = readings
    .isGreaterThanOrEqual(0.0)
    .and(readings.isLessThanOrEqual(50.0))

let cleanData = readings.masked(by: valid)
// [23.5, 24.1, 23.8, 24.2, 23.9]

let validCount = valid.trueIndices.count  // 5 out of 7
let dataQuality = Double(validCount) / Double(readings.count)  // 71% valid
```

### Missing data patterns

Identify and handle gaps in time-series data:

```swift
// Daily user engagement (0 = missing data)
let engagement = [85.0, 92.0, 0.0, 88.0, 91.0, 0.0, 0.0, 89.0]

// Find missing data points
let hasData = engagement.isGreaterThan(0.0)
let missingDays = hasData.not.trueIndices.count  // 3 missing days

// Calculate statistics only on valid data
let validEngagement = engagement.masked(by: hasData)
let avgEngagement = validEngagement.mean()  // 89.0
```

## Comparing datasets

### A/B testing analysis

Compare two variants to understand which performs better:

```swift
// Comparing two variants
let variantA = [0.12, 0.15, 0.13, 0.14, 0.16, 0.12, 0.15]
let variantB = [0.18, 0.19, 0.17, 0.20, 0.18, 0.19, 0.17]

// Compare central tendency
let avgA = variantA.mean()  // 0.139 (13.9%)
let avgB = variantB.mean()  // 0.183 (18.3%)
let improvement = ((avgB ?? 0) - (avgA ?? 0)) / (avgA ?? 0) * 100  // 31.7% increase

// Compare consistency
let stdA = variantA.std()  // 0.015
let stdB = variantB.std()  // 0.011
// Variant B is both better AND more consistent
```

### Time-series comparison

Compare performance across time periods:

```swift
// Period 1 vs Period 2 metrics
let period1 = [0.85, 0.83, 0.82, 0.84, 0.83, 0.81, 0.82]
let period2 = [0.88, 0.87, 0.86, 0.89, 0.87, 0.88, 0.87]

let avgPeriod1 = period1.mean()  // 0.829
let avgPeriod2 = period2.mean()  // 0.874

// Check if improvement is consistent
let diff = zip(period2, period1)
    .map { $0.0 - $0.1 }
let allImproved = diff.allSatisfy { $0 > 0 }  // true - consistent improvement
```

## Data normalization

### Z-score normalization

Standardize data to have mean=0 and std=1:

```swift
// Rating scores from different scales
let ratings = [3.5, 4.2, 3.8, 4.5, 3.9, 4.1]

guard let mean = ratings.mean(), let std = ratings.std() else { return }

// Normalize: (value - mean) / std
let normalized = ratings.map { ($0 - mean) / std }
// Now centered at 0 with std of 1

// Useful for comparing different metrics on same scale
```

### Min-max scaling

Scale data to a specific range (e.g., 0-1):

```swift
// Usage metrics with different scales
let usage = [2.5, 15.0, 8.3, 12.5, 5.0, 20.0, 3.5]

guard let min = usage.min(), let max = usage.max() else { return }

// Scale to 0-1 range
let scaled = usage.map { ($0 - min) / (max - min) }
// [0.0, 0.71, 0.33, 0.57, 0.14, 1.0, 0.06]

// Useful for visualization and comparing different metrics
```

## Cumulative statistics

### Running totals

Track cumulative values over time:

```swift
// Daily revenue
let dailyRevenue = [1200.0, 1350.0, 1280.0, 1400.0, 1320.0]

// Running total revenue
let cumulativeRevenue = dailyRevenue.cumulativeSum()
// [1200.0, 2550.0, 3830.0, 5230.0, 6550.0]

// Track progress toward monthly goal
let monthlyGoal = 30000.0
let currentProgress = cumulativeRevenue.last ?? 0
let percentComplete = (currentProgress / monthlyGoal) * 100  // 21.8%
```

### Growth rates

Calculate period-over-period growth:

```swift
// Monthly active users
let mau = [10000.0, 12000.0, 14500.0, 16800.0]

// Calculate growth rates
let growthRates = zip(mau.dropFirst(), mau).map { current, previous in
    ((current - previous) / previous) * 100
}
// [20.0%, 20.8%, 15.9%] - growth is slowing

let avgGrowth = growthRates.mean()  // 18.9% average monthly growth
```

## See also

- <doc:Statistics> - Complete API reference for statistical operations
- <doc:Elements> - Boolean operations for data filtering
- <doc:Primer> - Linear algebra fundamentals
