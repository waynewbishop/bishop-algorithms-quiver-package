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

        XCTAssertEqual(mask.count, 7)
        XCTAssertEqual(mask[5], true)  // 35.0 - outlier
        XCTAssertEqual(mask.filter { $0 }.count, 1)
    }

    func testOutlierMaskPreCalculatedStats() {
        let data = [4.0, 7.0, 2.0, 9.0, 3.0, 35.0, 5.0]

        guard let mean = data.mean(), let std = data.std() else {
            XCTFail("Unable to calculate statistics")
            return
        }

        let mask1 = data.outlierMask(threshold: 2.0)
        let mask2 = data.outlierMask(threshold: 2.0, mean: mean, std: std)
        XCTAssertEqual(mask1, mask2)
    }

    func testOutlierMaskEdgeCases() {
        // Empty array
        XCTAssertEqual([Double]().outlierMask(threshold: 2.0), [])

        // Single element
        let single = [5.0].outlierMask(threshold: 2.0)
        XCTAssertEqual(single, [false])

        // No outliers
        let normal = [1.0, 2.0, 3.0, 4.0, 5.0]
        XCTAssertEqual(normal.outlierMask(threshold: 2.0).filter { $0 }.count, 0)
    }

    func testOutlierMaskWithMaskedBy() {
        let data = [4.0, 7.0, 2.0, 9.0, 3.0, 35.0, 5.0]
        let mask = data.outlierMask(threshold: 2.0)
        let outliers = data.masked(by: mask)

        XCTAssertEqual(outliers.count, 1)
        XCTAssertEqual(outliers.first, 35.0)
    }

    // MARK: - Vector Array Operations Tests

    func testMeanVector() {
        let vectors = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
        let mean = vectors.meanVector()

        XCTAssertNotNil(mean)
        XCTAssertEqual(mean![0], 4.0, accuracy: 0.001)
        XCTAssertEqual(mean![1], 5.0, accuracy: 0.001)
        XCTAssertEqual(mean![2], 6.0, accuracy: 0.001)
    }

    func testMeanVectorEdgeCases() {
        // Empty array
        XCTAssertNil(([[Double]]()).meanVector())

        // Inconsistent dimensions
        XCTAssertNil([[1.0, 2.0], [3.0, 4.0, 5.0]].meanVector())
    }

    func testMeanVectorWordEmbeddings() {
        let wordEmbeddings = [
            [0.2, 0.5, -0.3, 0.8],
            [0.1, 0.6, 0.2, -0.4]
        ]
        let contextVector = wordEmbeddings.meanVector()

        XCTAssertNotNil(contextVector)
        XCTAssertEqual(contextVector![0], 0.15, accuracy: 0.001)
        XCTAssertEqual(contextVector![1], 0.55, accuracy: 0.001)
        XCTAssertEqual(contextVector![2], -0.05, accuracy: 0.001)
        XCTAssertEqual(contextVector![3], 0.2, accuracy: 0.001)
    }
}
