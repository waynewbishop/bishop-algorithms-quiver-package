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
    
}
