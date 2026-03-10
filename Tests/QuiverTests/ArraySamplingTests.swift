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

final class ArraySamplingTests: XCTestCase {

    // Split preserves all elements with correct partition sizes
    func testBasicPartition() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        let (train, test) = data.trainTestSplit(testRatio: 0.2, seed: 42)

        XCTAssertEqual(train.count, 8)
        XCTAssertEqual(test.count, 2)

        // Verify no elements lost or duplicated
        var all = train
        all.append(contentsOf: test)
        XCTAssertEqual(Set(all), Set(data))
    }

    // Same seed produces identical results every time
    func testReproducibility() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]

        let first = data.trainTestSplit(testRatio: 0.2, seed: 42)
        let second = data.trainTestSplit(testRatio: 0.2, seed: 42)

        XCTAssertEqual(first.train, second.train)
        XCTAssertEqual(first.test, second.test)
    }

    // Same seed on paired arrays keeps elements aligned
    func testPairedArrayConsistency() {
        let features = [10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0]
        let labels = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]

        let (trainX, testX) = features.trainTestSplit(testRatio: 0.2, seed: 7)
        let (trainY, testY) = labels.trainTestSplit(testRatio: 0.2, seed: 7)

        XCTAssertEqual(trainX.count, trainY.count)
        XCTAssertEqual(testX.count, testY.count)

        // Verify alignment — each label should match its feature's original index
        for i in 0..<trainX.count {
            let featureIndex = Int(trainX[i] / 10.0) - 1
            let expectedLabel = labels[featureIndex]
            XCTAssertEqual(trainY[i], expectedLabel)
        }
    }

    // Different seeds produce different splits
    func testDifferentSeedsDiffer() {
        let data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]

        let first = data.trainTestSplit(testRatio: 0.2, seed: 42)
        let second = data.trainTestSplit(testRatio: 0.2, seed: 99)

        XCTAssertNotEqual(first.train, second.train)
    }

    // Various ratios produce correct partition sizes
    func testRatioSizes() {
        let data = Array(0..<100)

        let split10 = data.trainTestSplit(testRatio: 0.1, seed: 1)
        XCTAssertEqual(split10.test.count, 10)
        XCTAssertEqual(split10.train.count, 90)

        let split50 = data.trainTestSplit(testRatio: 0.5, seed: 1)
        XCTAssertEqual(split50.test.count, 50)
        XCTAssertEqual(split50.train.count, 50)

        let split90 = data.trainTestSplit(testRatio: 0.9, seed: 1)
        XCTAssertEqual(split90.test.count, 90)
        XCTAssertEqual(split90.train.count, 10)
    }
}
