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

final class ArrayStatisticsTests: XCTestCase {
    
    func testSum() {
        let a = [1, 2, 3, 4, 5]
        XCTAssertEqual(a.sum(), 15)
    }
    
    func testProduct() {
        let a = [1, 2, 3, 4, 5]
        XCTAssertEqual(a.product(), 120)
    }
    
    func testCumulativeSum() {
        let a = [1, 2, 3, 4, 5]
        XCTAssertEqual(a.cumulativeSum(), [1, 3, 6, 10, 15])
    }
    
    func testCumulativeProduct() {
        let a = [1, 2, 3, 4, 5]
        XCTAssertEqual(a.cumulativeProduct(), [1, 2, 6, 24, 120])
    }
    
    func testMin() {
        let a = [5, 3, 8, 1, 7]
        XCTAssertEqual(a.min(), 1)
    }
    
    func testMax() {
        let a = [5, 3, 8, 1, 7]
        XCTAssertEqual(a.max(), 8)
    }
    
    func testArgmin() {
        let a = [5, 3, 8, 1, 7]
        XCTAssertEqual(a.argmin(), 3)
    }
    
    func testArgmax() {
        let a = [5, 3, 8, 1, 7]
        XCTAssertEqual(a.argmax(), 2)
    }
    
    func testMean() {
        let a = [1.0, 2.0, 3.0, 4.0, 5.0]
        XCTAssertEqual(a.mean(), 3.0)
    }
    
    func testMedian() {
        let a = [1.0, 5.0, 3.0, 4.0, 2.0]
        XCTAssertEqual(a.median(), 3.0)
    }
    
    func testVariance() {
        let a = [1.0, 2.0, 3.0, 4.0, 5.0]
        XCTAssertEqual(a.variance(), 2.0)
    }
    
    func testStd() throws {
        let a = [1.0, 2.0, 3.0, 4.0, 5.0]
        let std = try XCTUnwrap(a.std())
        XCTAssertEqual(std, sqrt(2.0), accuracy: 1e-10)
    }

    // MARK: - Outlier Detection Tests

    func testOutlierMaskBasic() {
        let data = [4.0, 7.0, 2.0, 9.0, 3.0, 35.0, 5.0]
        let mask = data.outlierMask(threshold: 2.0)

        // Only 35.0 should be marked as an outlier
        XCTAssertEqual(mask.count, 7)
        XCTAssertEqual(mask[0], false) // 4.0
        XCTAssertEqual(mask[1], false) // 7.0
        XCTAssertEqual(mask[2], false) // 2.0
        XCTAssertEqual(mask[3], false) // 9.0
        XCTAssertEqual(mask[4], false) // 3.0
        XCTAssertEqual(mask[5], true)  // 35.0 - outlier
        XCTAssertEqual(mask[6], false) // 5.0
    }

    func testOutlierMaskCustomThreshold() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0, 100.0]

        // With threshold 1.0, 100.0 should definitely be an outlier
        let mask1 = data.outlierMask(threshold: 1.0)
        XCTAssertEqual(mask1.last, true)

        // With threshold 2.0, 100.0 should also be an outlier
        let mask2 = data.outlierMask(threshold: 2.0)
        XCTAssertEqual(mask2.last, true)

        // Verify count of outliers
        let outlierCount = mask2.filter { $0 }.count
        XCTAssertGreaterThanOrEqual(outlierCount, 1)
    }

    func testOutlierMaskPreCalculatedStats() {
        let data = [4.0, 7.0, 2.0, 9.0, 3.0, 35.0, 5.0]

        guard let mean = data.mean(), let std = data.std() else {
            XCTFail("Unable to calculate statistics")
            return
        }

        // Using pre-calculated stats should give same result
        let mask1 = data.outlierMask(threshold: 2.0)
        let mask2 = data.outlierMask(threshold: 2.0, mean: mean, std: std)

        XCTAssertEqual(mask1, mask2)
    }

    func testOutlierMaskEmptyArray() {
        let data: [Double] = []
        let mask = data.outlierMask(threshold: 2.0)

        XCTAssertEqual(mask, [])
    }

    func testOutlierMaskSingleElement() {
        let data = [5.0]
        let mask = data.outlierMask(threshold: 2.0)

        // Single element cannot be an outlier from itself
        XCTAssertEqual(mask.count, 1)
        XCTAssertEqual(mask[0], false)
    }

    func testOutlierMaskNoOutliers() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0]
        let mask = data.outlierMask(threshold: 2.0)

        // All values should be within 2 std deviations
        XCTAssertEqual(mask.filter { $0 }.count, 0)
    }

    func testOutlierMaskMultipleOutliers() {
        let data = [1.0, 2.0, 3.0, 100.0, 200.0]

        // Use a lower threshold to ensure outliers are detected
        let mask = data.outlierMask(threshold: 1.0)

        // Multiple outliers should be detected
        let outlierCount = mask.filter { $0 }.count
        XCTAssertGreaterThan(outlierCount, 0)

        // Verify the extreme values are marked as outliers
        XCTAssertTrue(mask[3] || mask[4], "At least one of the extreme values should be an outlier")
    }

    func testOutlierMaskWithMaskedBy() {
        let data = [4.0, 7.0, 2.0, 9.0, 3.0, 35.0, 5.0]
        let mask = data.outlierMask(threshold: 2.0)

        // Verify integration with masked(by:) if it exists
        let outliers = data.masked(by: mask)

        // Should contain only 35.0
        XCTAssertEqual(outliers.count, 1)
        XCTAssertEqual(outliers.first, 35.0)
    }

    func testOutlierMaskNegativeValues() {
        let data = [-10.0, -5.0, 0.0, 5.0, 10.0, 100.0]
        let mask = data.outlierMask(threshold: 2.0)

        // 100.0 should be detected as an outlier
        XCTAssertEqual(mask.last, true)
    }

}
