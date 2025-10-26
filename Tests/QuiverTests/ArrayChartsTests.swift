// Copyright 2025 Wayne W Bishop. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import XCTest
@testable import Quiver

final class ArrayChartsTests: XCTestCase {

    // MARK: - Time Series Tests

    func testRollingMean() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0]
        let result = data.rollingMean(window: 3)

        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result[0], 1.0, accuracy: 1e-10)  // [1] avg
        XCTAssertEqual(result[1], 1.5, accuracy: 1e-10)  // [1,2] avg
        XCTAssertEqual(result[2], 2.0, accuracy: 1e-10)  // [1,2,3] avg
        XCTAssertEqual(result[3], 3.0, accuracy: 1e-10)  // [2,3,4] avg
        XCTAssertEqual(result[4], 4.0, accuracy: 1e-10)  // [3,4,5] avg
    }

    func testRollingMeanWindowLargerThanArray() {
        let data = [1.0, 2.0, 3.0]
        let result = data.rollingMean(window: 10)

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], 2.0, accuracy: 1e-10)  // mean of all
    }

    func testDiff() {
        let data = [10.0, 12.0, 11.0, 13.0, 15.0]
        let result = data.diff()

        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result, [2.0, -1.0, 2.0, 2.0])
    }

    func testPercentChange() {
        let data = [100.0, 120.0, 110.0, 130.0]
        let result = data.percentChange()

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], 20.0, accuracy: 1e-10)    // (120-100)/100 * 100
        XCTAssertEqual(result[1], -8.333333, accuracy: 1e-5) // (110-120)/120 * 100
        XCTAssertEqual(result[2], 18.181818, accuracy: 1e-5) // (130-110)/110 * 100
    }

    // MARK: - Distribution Tests

    func testHistogram() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        let result = data.histogram(bins: 5)

        XCTAssertEqual(result.count, 5)
        // Each bin should have 2 values
        XCTAssertEqual(result[0].count, 2)
        XCTAssertEqual(result[1].count, 2)
        XCTAssertEqual(result[2].count, 2)
        XCTAssertEqual(result[3].count, 2)
        XCTAssertEqual(result[4].count, 2)
    }

    func testHistogramSingleValue() {
        let data = [5.0, 5.0, 5.0]
        let result = data.histogram(bins: 3)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].midpoint, 5.0)
        XCTAssertEqual(result[0].count, 3)
    }

    func testQuartiles() throws {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        let result = try XCTUnwrap(data.quartiles())

        XCTAssertEqual(result.min, 1.0)
        XCTAssertEqual(result.max, 10.0)
        XCTAssertEqual(result.median, 5.5, accuracy: 1e-10)
        // Q1 at 25th percentile: position = 0.25 * 9 = 2.25, interpolate between indices 2 and 3
        XCTAssertEqual(result.q1, 3.25, accuracy: 1e-10)  // 3 + 0.25*(4-3) = 3.25
        // Q3 at 75th percentile: position = 0.75 * 9 = 6.75, interpolate between indices 6 and 7
        XCTAssertEqual(result.q3, 7.75, accuracy: 1e-10)  // 7 + 0.75*(8-7) = 7.75
        XCTAssertEqual(result.iqr, 4.5, accuracy: 1e-10)  // 7.75 - 3.25 = 4.5
    }

    func testPercentile() throws {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]

        let p0 = try XCTUnwrap(data.percentile(0))
        let p50 = try XCTUnwrap(data.percentile(50))
        let p100 = try XCTUnwrap(data.percentile(100))

        XCTAssertEqual(p0, 1.0, accuracy: 1e-10)
        XCTAssertEqual(p50, 5.5, accuracy: 1e-10)
        XCTAssertEqual(p100, 10.0, accuracy: 1e-10)
    }

    func testPercentileRank() {
        let data = [85.0, 92.0, 78.0, 88.0, 95.0]
        let rank = data.percentileRank(of: 88.0)

        // 2 values below (78, 85), 1 equal (88), total 5
        // (2 + 1/2) / 5 * 100 = 50%
        XCTAssertEqual(rank, 50.0, accuracy: 1e-10)
    }

    // MARK: - Normalization Tests

    func testScaled() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0]
        let result = data.scaled(to: 0...10)

        XCTAssertEqual(result[0], 0.0, accuracy: 1e-10)
        XCTAssertEqual(result[1], 2.5, accuracy: 1e-10)
        XCTAssertEqual(result[2], 5.0, accuracy: 1e-10)
        XCTAssertEqual(result[3], 7.5, accuracy: 1e-10)
        XCTAssertEqual(result[4], 10.0, accuracy: 1e-10)
    }

    func testAsPercentages() {
        let data = [25.0, 50.0, 75.0, 100.0]
        let result = data.asPercentages()

        XCTAssertEqual(result[0], 10.0, accuracy: 1e-10)
        XCTAssertEqual(result[1], 20.0, accuracy: 1e-10)
        XCTAssertEqual(result[2], 30.0, accuracy: 1e-10)
        XCTAssertEqual(result[3], 40.0, accuracy: 1e-10)
    }

    func testStandardized() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0]
        let result = data.standardized()

        // Mean = 3.0, std ~= 1.414
        // (1-3)/1.414 ~= -1.414
        // (3-3)/1.414 = 0
        // (5-3)/1.414 ~= 1.414
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result[2], 0.0, accuracy: 1e-10)  // Middle value
        XCTAssertTrue(result[0] < 0)  // Below mean
        XCTAssertTrue(result[4] > 0)  // Above mean
    }

    // MARK: - Grouping Tests

    func testGroupBy() {
        let values = [100.0, 200.0, 150.0, 300.0]
        let categories = ["A", "B", "A", "B"]
        let result = values.groupBy(categories, using: .sum)

        XCTAssertEqual(result["A"], 250.0)  // 100 + 150
        XCTAssertEqual(result["B"], 500.0)  // 200 + 300
    }

    func testGroupByMean() throws {
        let values = [100.0, 200.0, 150.0, 300.0]
        let categories = ["A", "B", "A", "B"]
        let result = values.groupBy(categories, using: .mean)

        let meanA = try XCTUnwrap(result["A"])
        let meanB = try XCTUnwrap(result["B"])

        XCTAssertEqual(meanA, 125.0, accuracy: 1e-10)  // (100 + 150) / 2
        XCTAssertEqual(meanB, 250.0, accuracy: 1e-10)  // (200 + 300) / 2
    }

    func testGroupedData() {
        let values = [100.0, 200.0, 150.0]
        let categories = ["B", "A", "B"]
        let result = values.groupedData(by: categories, using: .sum)

        // Should be sorted by category name
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].category, "A")
        XCTAssertEqual(result[0].value, 200.0)
        XCTAssertEqual(result[1].category, "B")
        XCTAssertEqual(result[1].value, 250.0)
    }

    // MARK: - Multi-Series Tests

    func testStackedCumulative() {
        let series1 = [10.0, 20.0, 30.0]
        let series2 = [5.0, 10.0, 15.0]
        let series3 = [2.0, 4.0, 6.0]

        let result = [series1, series2, series3].stackedCumulative()

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], [10.0, 20.0, 30.0])         // First series
        XCTAssertEqual(result[1], [15.0, 30.0, 45.0])         // series1 + series2
        XCTAssertEqual(result[2], [17.0, 34.0, 51.0])         // series1 + series2 + series3
    }

    func testStackedPercentage() {
        let series1 = [50.0, 40.0]
        let series2 = [30.0, 60.0]
        let series3 = [20.0, 0.0]

        let result = [series1, series2, series3].stackedPercentage()

        XCTAssertEqual(result.count, 3)
        // Time 0: total = 100, Time 1: total = 100
        XCTAssertEqual(result[0][0], 50.0, accuracy: 1e-10)  // 50/100 * 100
        XCTAssertEqual(result[0][1], 40.0, accuracy: 1e-10)  // 40/100 * 100
        XCTAssertEqual(result[1][0], 30.0, accuracy: 1e-10)  // 30/100 * 100
        XCTAssertEqual(result[1][1], 60.0, accuracy: 1e-10)  // 60/100 * 100
    }

    func testCorrelationMatrix() {
        let series1 = [1.0, 2.0, 3.0, 4.0, 5.0]
        let series2 = [1.0, 2.0, 3.0, 4.0, 5.0]  // Perfect correlation
        let series3 = [5.0, 4.0, 3.0, 2.0, 1.0]  // Perfect negative correlation

        let result = [series1, series2, series3].correlationMatrix()

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0][0], 1.0, accuracy: 1e-10)   // Self correlation
        XCTAssertEqual(result[0][1], 1.0, accuracy: 1e-10)   // Perfect positive
        XCTAssertEqual(result[0][2], -1.0, accuracy: 1e-10)  // Perfect negative
    }

    func testHeatmapData() {
        let series1 = [1.0, 2.0, 3.0]
        let series2 = [1.0, 2.0, 3.0]

        let result = [series1, series2].heatmapData(labels: ["A", "B"])

        XCTAssertEqual(result.count, 4)  // 2x2 matrix
        XCTAssertEqual(result[0].x, "A")
        XCTAssertEqual(result[0].y, "A")
        XCTAssertEqual(result[0].value, 1.0, accuracy: 1e-10)
    }

    // MARK: - Downsampling Tests

    func testDownsample() {
        let hourlyData = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0]
        let result = hourlyData.downsample(factor: 3, using: .mean)

        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], 2.0, accuracy: 1e-10)   // (1+2+3)/3
        XCTAssertEqual(result[1], 5.0, accuracy: 1e-10)   // (4+5+6)/3
        XCTAssertEqual(result[2], 8.0, accuracy: 1e-10)   // (7+8+9)/3
        XCTAssertEqual(result[3], 11.0, accuracy: 1e-10)  // (10+11+12)/3
    }

    func testDownsampleSum() {
        let data = [10.0, 20.0, 30.0, 40.0]
        let result = data.downsample(factor: 2, using: .sum)

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], 30.0)  // 10 + 20
        XCTAssertEqual(result[1], 70.0)  // 30 + 40
    }

    // MARK: - Edge Cases

    func testEmptyArray() {
        let empty: [Double] = []

        XCTAssertEqual(empty.rollingMean(window: 3), [])
        XCTAssertTrue(empty.histogram(bins: 5).isEmpty)
        XCTAssertNil(empty.quartiles())
        XCTAssertEqual(empty.asPercentages(), [])
    }

    func testSingleElement() {
        let single = [5.0]

        XCTAssertEqual(single.rollingMean(window: 1), [5.0])
        XCTAssertEqual(single.asPercentages(), [100.0])  // Single element is 100% of total
    }
}
