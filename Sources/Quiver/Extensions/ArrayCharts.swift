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

    /// Calculate rolling mean (moving average) over a specified window
    /// - Parameter window: The size of the rolling window
    /// - Returns: Array of rolling means with same length as input
    func rollingMean(window: Int) -> [Element] {
        guard window > 0 && !isEmpty else { return [] }
        guard window <= count else { return Array(repeating: mean() ?? .zero, count: count) }

        var result: [Element] = []
        result.reserveCapacity(count)

        for i in 0..<count {
            let start = Swift.max(0, i - window + 1)
            let slice = Array(self[start...i])
            let sliceSum = slice.reduce(Element.zero, +)
            let sliceMean = sliceSum / Element(slice.count)
            result.append(sliceMean)
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

    /// Calculate histogram bins for the data
    /// - Parameter bins: Number of bins to create
    /// - Returns: Array of tuples containing (midpoint, count) for each bin
    func histogram(bins: Int) -> [(midpoint: Element, count: Int)] {
        guard bins > 0 && !isEmpty else { return [] }

        guard let minVal = self.min(), let maxVal = self.max() else {
            return []
        }

        // Handle case where all values are the same
        guard minVal != maxVal else {
            return [(midpoint: minVal, count: count)]
        }

        let binWidth = (maxVal - minVal) / Element(bins)
        var result: [(Element, Int)] = []

        for i in 0..<bins {
            let lower = minVal + Element(i) * binWidth
            let upper = lower + binWidth
            let midpoint = (lower + upper) / Element(2)

            // For last bin, include upper boundary
            let binCount: Int
            if i == bins - 1 {
                binCount = self.filter { $0 >= lower && $0 <= upper }.count
            } else {
                binCount = self.filter { $0 >= lower && $0 < upper }.count
            }

            result.append((midpoint, binCount))
        }

        return result
    }

    /// Calculate quartiles (Q1, median, Q3) and interquartile range
    /// - Returns: Tuple containing min, Q1, median, Q3, max, and IQR, or nil if empty
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

        let belowCount = self.filter { $0 < value }.count
        let equalCount = self.filter { $0 == value }.count

        let rank = (Element(belowCount) + Element(equalCount) / Element(2)) / Element(count) * Element(100)
        return rank
    }

    /// Calculate percentile ranks for all values in the array
    /// - Returns: Array of percentile ranks corresponding to each value
    func percentileRanks() -> [Element] {
        return map { percentileRank(of: $0) }
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

    /// Calculate correlation matrix for multiple series
    /// - Returns: 2D array representing correlation coefficients between all series pairs
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
