// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import Foundation

// MARK: - Chart Helper Functions

/// Aggregation methods for groupBy operations
public enum AggregationMethod {
    case sum
    case mean
    case count
    case min
    case max
}

public extension Array where Element: FloatingPoint {

    // MARK: - Time Series Operations

    /// Calculates a rolling mean (moving average) over a specified window.
    ///
    /// The rolling mean smooths noisy data by replacing each value with the average of its
    /// surrounding values within the window. This is essential for identifying trends in
    /// time-series data by filtering out short-term fluctuations. The result has the same
    /// length as the input, with early values averaged over a smaller partial window.
    ///
    /// Common uses:
    /// - **Stock prices**: Smooth daily volatility to reveal weekly or monthly trends
    /// - **Sensor data**: Filter noise from temperature, pressure, or motion readings
    /// - **Performance metrics**: Identify sustained patterns in latency or throughput
    ///
    /// Example:
    /// ```swift
    /// let dailySales = [120.0, 95.0, 140.0, 110.0, 130.0, 85.0, 150.0]
    ///
    /// let trend = dailySales.rollingMean(window: 3)
    /// // [120.0, 107.5, 118.33, 115.0, 126.67, 108.33, 121.67]
    /// // Each value is the average of itself and up to 2 prior values
    /// ```
    ///
    /// - Parameter window: The number of consecutive elements to average together
    /// - Returns: Array of rolling means with the same length as the input
    func rollingMean(window: Int) -> [Element] {
        guard window > 0 && !isEmpty else { return [] }
        guard window <= count else { return Array(repeating: mean() ?? .zero, count: count) }

        var result: [Element] = []
        result.reserveCapacity(count)

        // Sliding window: maintain running sum instead of recalculating each iteration
        var runningSum = Element.zero

        for i in 0..<count {
            runningSum += self[i]

            // Remove the element that just fell out of the window
            if i >= window {
                runningSum -= self[i - window]
            }

            let windowSize = Swift.min(i + 1, window)
            result.append(runningSum / Element(windowSize))
        }

        return result
    }

    /// Calculate period-over-period difference
    /// - Parameter lag: Number of periods to lag (default: 1)
    /// - Returns: Array of differences (length = count - lag)
    func diff(lag: Int = 1) -> [Element] {
        guard lag > 0 && lag < count else { return [] }

        var result: [Element] = []
        result.reserveCapacity(count - lag)

        for i in lag..<count {
            result.append(self[i] - self[i - lag])
        }

        return result
    }

    /// Calculate period-over-period percentage change
    /// - Parameter lag: Number of periods to lag (default: 1)
    /// - Returns: Array of percentage changes
    func percentChange(lag: Int = 1) -> [Element] {
        guard lag > 0 && lag < count else { return [] }

        var result: [Element] = []
        result.reserveCapacity(count - lag)

        for i in lag..<count {
            let previous = self[i - lag]
            guard previous != .zero else {
                result.append(.zero)
                continue
            }
            let change = ((self[i] - previous) / previous) * Element(100)
            result.append(change)
        }

        return result
    }

    // MARK: - Distribution Analysis

    /// Divides data into evenly spaced bins and counts the frequency of values in each.
    ///
    /// A histogram reveals the shape of a data distribution — whether values cluster around
    /// a central peak, spread uniformly, or skew toward one end. Each bin spans an equal
    /// range, and the result provides the midpoint and count for every bin, ready for
    /// visualization or further analysis.
    ///
    /// Common uses:
    /// - **Data exploration**: Understand the distribution before applying statistical models
    /// - **Quality control**: Detect bimodal patterns or unexpected outliers
    /// - **Feature engineering**: Identify natural breakpoints for discretizing continuous data
    ///
    /// Example:
    /// ```swift
    /// let scores = [72.0, 85.0, 90.0, 78.0, 92.0, 88.0, 76.0, 95.0, 81.0, 87.0]
    ///
    /// let distribution = scores.histogram(bins: 4)
    /// // [(midpoint: 74.875, count: 3),
    /// //  (midpoint: 80.625, count: 2),
    /// //  (midpoint: 86.375, count: 2),
    /// //  (midpoint: 92.125, count: 3)]
    /// ```
    ///
    /// - Parameter bins: The number of equal-width bins to create
    /// - Returns: Array of tuples containing the midpoint and count for each bin
    func histogram(bins: Int) -> [(midpoint: Element, count: Int)] where Element: BinaryFloatingPoint {
        guard bins > 0 && !isEmpty else { return [] }

        guard let minVal = self.min(), let maxVal = self.max() else {
            return []
        }

        // Handle case where all values are the same
        guard minVal != maxVal else {
            return [(midpoint: minVal, count: count)]
        }

        let binWidth = (maxVal - minVal) / Element(bins)

        // Single pass: assign each element to its bin using arithmetic
        var counts = [Int](repeating: 0, count: bins)
        for value in self {
            var index = Int((value - minVal) / binWidth)
            // Clamp the max value into the last bin
            if index >= bins { index = bins - 1 }
            counts[index] += 1
        }

        // Build result with midpoints
        var result: [(Element, Int)] = []
        for i in 0..<bins {
            let lower = minVal + Element(i) * binWidth
            let midpoint = lower + binWidth / Element(2)
            result.append((midpoint, counts[i]))
        }

        return result
    }

    /// Calculates the five-number summary and interquartile range of the data.
    ///
    /// Quartiles divide sorted data into four equal parts, providing a robust summary
    /// that is resistant to outliers. The interquartile range (IQR) — the distance between
    /// Q1 and Q3 — captures where the middle 50% of values fall, making it a reliable
    /// measure of spread for skewed distributions.
    ///
    /// Returned values:
    /// - **min / max**: The smallest and largest values
    /// - **q1**: The 25th percentile (lower quartile)
    /// - **median**: The 50th percentile (middle value)
    /// - **q3**: The 75th percentile (upper quartile)
    /// - **iqr**: The interquartile range (q3 - q1)
    ///
    /// Example:
    /// ```swift
    /// let responseTimes = [12.0, 15.0, 18.0, 22.0, 25.0, 30.0, 45.0, 120.0]
    ///
    /// if let stats = responseTimes.quartiles() {
    ///     // stats.min     = 12.0
    ///     // stats.q1      = 16.5
    ///     // stats.median  = 23.5
    ///     // stats.q3      = 37.5
    ///     // stats.max     = 120.0
    ///     // stats.iqr     = 21.0
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing the five-number summary and IQR, or nil if the array is empty
    func quartiles() -> (min: Element, q1: Element, median: Element, q3: Element, max: Element, iqr: Element)? where Element: BinaryFloatingPoint {
        guard !isEmpty else { return nil }

        let sorted = self.sorted()
        guard let minVal = sorted.first, let maxVal = sorted.last else {
            return nil
        }

        // Use percentile method for consistency
        let medianValue = percentile(50.0) ?? .zero
        let q1Value = percentile(25.0) ?? .zero
        let q3Value = percentile(75.0) ?? .zero

        let iqr = q3Value - q1Value

        return (min: minVal, q1: q1Value, median: medianValue, q3: q3Value, max: maxVal, iqr: iqr)
    }

    /// Calculate specific percentile value
    /// - Parameter p: Percentile to calculate (0-100)
    /// - Returns: Value at the specified percentile, or nil if array is empty
    func percentile(_ p: Double) -> Element? where Element: BinaryFloatingPoint {
        guard !isEmpty else { return nil }
        guard p >= 0 && p <= 100 else { return nil }

        let sorted = self.sorted()
        let indexDouble = (p / 100.0) * Double(sorted.count - 1)
        let lowerIndex = Int(indexDouble)
        let upperIndex = Swift.min(lowerIndex + 1, sorted.count - 1)
        let fraction = Element(indexDouble - Double(lowerIndex))

        return sorted[lowerIndex] + fraction * (sorted[upperIndex] - sorted[lowerIndex])
    }

    /// Calculate percentile rank for a specific value
    /// - Parameter value: Value to find percentile rank for
    /// - Returns: Percentile rank (0-100)
    func percentileRank(of value: Element) -> Element {
        guard !isEmpty else { return .zero }

        // Single pass: count below and equal simultaneously
        var belowCount = 0
        var equalCount = 0
        for element in self {
            if element < value {
                belowCount += 1
            } else if element == value {
                equalCount += 1
            }
        }

        let rank = (Element(belowCount) + Element(equalCount) / Element(2)) / Element(count) * Element(100)
        return rank
    }

    /// Calculate percentile ranks for all values in the array
    /// - Returns: Array of percentile ranks corresponding to each value
    func percentileRanks() -> [Element] {
        guard !isEmpty else { return [] }

        // Sort once and compute all ranks in a single pass
        let sorted = self.enumerated().sorted { $0.element < $1.element }
        var ranks = [Element](repeating: .zero, count: count)

        var i = 0
        while i < sorted.count {
            // Find the range of equal values
            var j = i
            while j < sorted.count && sorted[j].element == sorted[i].element {
                j += 1
            }

            // All equal values share the same rank
            let belowCount = i
            let equalCount = j - i
            let rank = (Element(belowCount) + Element(equalCount) / Element(2)) / Element(count) * Element(100)

            for k in i..<j {
                ranks[sorted[k].offset] = rank
            }

            i = j
        }

        return ranks
    }

    // MARK: - Normalization and Scaling

    /// Scale values to a custom range using min-max scaling
    /// - Parameter range: Target range (ClosedRange)
    /// - Returns: Array of scaled values
    func scaled(to range: ClosedRange<Element>) -> [Element] {
        guard !isEmpty else { return [] }
        guard let minVal = self.min(), let maxVal = self.max() else {
            return []
        }

        let dataRange = maxVal - minVal
        guard dataRange != .zero else {
            return Array(repeating: range.lowerBound, count: count)
        }

        let targetRange = range.upperBound - range.lowerBound
        return map { (($0 - minVal) / dataRange) * targetRange + range.lowerBound }
    }

    /// Convert values to percentages of total
    /// - Returns: Array where values represent percentage of total sum
    func asPercentages() -> [Element] {
        guard !isEmpty else { return [] }

        let total = reduce(Element.zero, +)
        guard total != .zero else {
            return Array(repeating: .zero, count: count)
        }

        return map { ($0 / total) * Element(100) }
    }

    /// Standardize values using z-score normalization (mean=0, std=1)
    /// - Returns: Array of standardized values, or empty array if std is zero
    func standardized() -> [Element] {
        guard !isEmpty else { return [] }
        guard let meanVal = mean(), let stdVal = std() else {
            return []
        }

        guard stdVal != .zero else {
            return Array(repeating: .zero, count: count)
        }

        return map { ($0 - meanVal) / stdVal }
    }

    // MARK: - Grouping and Aggregation

    /// Group values by categories and aggregate using specified method
    /// - Parameters:
    ///   - categories: Array of category labels (same length as values)
    ///   - method: Aggregation method to apply
    /// - Returns: Dictionary mapping categories to aggregated values
    func groupBy(_ categories: [String], using method: AggregationMethod) -> [String: Element] {
        guard categories.count == count else { return [:] }

        var groups: [String: [Element]] = [:]

        for (value, category) in zip(self, categories) {
            groups[category, default: []].append(value)
        }

        var result: [String: Element] = [:]

        for (category, values) in groups {
            switch method {
            case .sum:
                result[category] = values.reduce(Element.zero, +)
            case .mean:
                result[category] = values.mean() ?? .zero
            case .count:
                result[category] = Element(values.count)
            case .min:
                result[category] = values.min() ?? .zero
            case .max:
                result[category] = values.max() ?? .zero
            }
        }

        return result
    }

    /// Group values and return chart-ready array of tuples
    /// - Parameters:
    ///   - categories: Array of category labels (same length as values)
    ///   - method: Aggregation method to apply
    /// - Returns: Array of tuples (category, value) sorted by category name
    func groupedData(by categories: [String], using method: AggregationMethod) -> [(category: String, value: Element)] {
        let grouped = groupBy(categories, using: method)
        return grouped.map { ($0.key, $0.value) }.sorted { $0.category < $1.category }
    }
}

// MARK: - Multi-Series Operations

public extension Array where Element == [Double] {

    /// Stack multiple series cumulatively for stacked area/bar charts
    /// - Returns: Array of arrays where each series is cumulative sum of previous series
    func stackedCumulative() -> [[Double]] {
        guard !isEmpty else { return [] }
        guard let firstSeries = first else { return [] }

        var result: [[Double]] = []
        var cumulative = [Double](repeating: 0.0, count: firstSeries.count)

        for series in self {
            guard series.count == firstSeries.count else { continue }

            var stacked: [Double] = []
            for (i, value) in series.enumerated() {
                cumulative[i] += value
                stacked.append(cumulative[i])
            }
            result.append(stacked)
        }

        return result
    }

    /// Stack series as percentages (each time point sums to 100%)
    /// - Returns: Array of percentage-normalized series
    func stackedPercentage() -> [[Double]] {
        guard !isEmpty else { return [] }
        guard let firstSeries = first else { return [] }
        let seriesCount = firstSeries.count

        var result: [[Double]] = []

        // Calculate totals at each time point
        var totals = [Double](repeating: 0.0, count: seriesCount)
        for series in self {
            guard series.count == seriesCount else { continue }
            for (i, value) in series.enumerated() {
                totals[i] += value
            }
        }

        // Convert to percentages
        for series in self {
            var percentSeries: [Double] = []
            for (i, value) in series.enumerated() {
                if totals[i] != 0 {
                    percentSeries.append((value / totals[i]) * 100.0)
                } else {
                    percentSeries.append(0.0)
                }
            }
            result.append(percentSeries)
        }

        return result
    }

    /// Calculates the Pearson correlation matrix for multiple data series.
    ///
    /// The correlation matrix measures the linear relationship between every pair of series,
    /// with each cell containing a Pearson correlation coefficient. This reveals which
    /// variables move together (positive correlation), move inversely (negative correlation),
    /// or behave independently (near zero). The diagonal is always 1.0 since each series
    /// correlates perfectly with itself.
    ///
    /// Interpretation:
    /// - **1.0**: Perfect positive correlation (both rise and fall together)
    /// - **0.0**: No linear relationship
    /// - **-1.0**: Perfect negative correlation (one rises as the other falls)
    ///
    /// Example:
    /// ```swift
    /// let temperature = [30.0, 32.0, 35.0, 28.0, 33.0]
    /// let iceCream    = [200.0, 220.0, 260.0, 180.0, 230.0]
    /// let hotCocoa    = [150.0, 130.0, 100.0, 170.0, 120.0]
    ///
    /// let matrix = [temperature, iceCream, hotCocoa].correlationMatrix()
    /// // [[1.0,   0.99, -0.99],   // temperature
    /// //  [0.99,  1.0,  -0.98],   // ice cream
    /// //  [-0.99, -0.98, 1.0]]    // hot cocoa
    /// ```
    ///
    /// - Returns: A 2D array of Pearson correlation coefficients between all series pairs
    func correlationMatrix() -> [[Double]] {
        guard !isEmpty else { return [] }

        let n = count
        var matrix: [[Double]] = []

        for i in 0..<n {
            var row: [Double] = []
            for j in 0..<n {
                if i == j {
                    row.append(1.0)
                } else {
                    row.append(pearsonCorrelation(self[i], self[j]))
                }
            }
            matrix.append(row)
        }

        return matrix
    }

    /// Calculate Pearson correlation between two arrays
    private func pearsonCorrelation(_ x: [Double], _ y: [Double]) -> Double {
        guard x.count == y.count && !x.isEmpty else { return 0.0 }

        let n = Double(x.count)
        let meanX = x.reduce(0, +) / n
        let meanY = y.reduce(0, +) / n

        var numerator = 0.0
        var denomX = 0.0
        var denomY = 0.0

        for i in 0..<x.count {
            let diffX = x[i] - meanX
            let diffY = y[i] - meanY
            numerator += diffX * diffY
            denomX += diffX * diffX
            denomY += diffY * diffY
        }

        guard denomX > 0 && denomY > 0 else { return 0.0 }

        return numerator / Foundation.sqrt(denomX * denomY)
    }

    /// Flatten correlation matrix to chart-ready tuples
    /// - Parameter labels: Labels for each series
    /// - Returns: Array of (x, y, value) tuples for heatmap visualization
    func heatmapData(labels: [String]) -> [(x: String, y: String, value: Double)] {
        let matrix = correlationMatrix()
        guard matrix.count == labels.count else { return [] }

        var result: [(String, String, Double)] = []

        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                result.append((labels[i], labels[j], matrix[i][j]))
            }
        }

        return result
    }
}

// MARK: - Downsampling

public extension Array where Element: FloatingPoint {

    /// Downsample array by factor using specified aggregation method
    /// - Parameters:
    ///   - factor: Downsampling factor (e.g., 6 converts hourly to 6-hourly)
    ///   - method: How to aggregate values in each window
    /// - Returns: Downsampled array
    func downsample(factor: Int, using method: AggregationMethod) -> [Element] {
        guard factor > 0 && !isEmpty else { return [] }
        guard factor < count else { return [aggregate(using: method)] }

        var result: [Element] = []
        let chunkCount = (count + factor - 1) / factor
        result.reserveCapacity(chunkCount)

        for i in 0..<chunkCount {
            let start = i * factor
            let end = Swift.min(start + factor, count)
            let chunk = Array(self[start..<end])
            result.append(chunk.aggregate(using: method))
        }

        return result
    }

    /// Aggregate array using specified method
    private func aggregate(using method: AggregationMethod) -> Element {
        switch method {
        case .sum:
            return reduce(Element.zero, +)
        case .mean:
            return mean() ?? .zero
        case .count:
            return Element(count)
        case .min:
            return self.min() ?? .zero
        case .max:
            return self.max() ?? .zero
        }
    }
}
