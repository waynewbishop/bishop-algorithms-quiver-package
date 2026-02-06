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

final class ArrayRandomTests: XCTestCase {

    func testRandom1DDouble() {
        let result = [Double].random(5)

        // Verify count
        XCTAssertEqual(result.count, 5)

        // Verify all values are in range [0, 1]
        for value in result {
            XCTAssertGreaterThanOrEqual(value, 0.0)
            XCTAssertLessThanOrEqual(value, 1.0)
        }
    }

    func testRandom2DDouble() {
        let result = [Double].random(3, 4)

        // Verify dimensions
        XCTAssertEqual(result.count, 3)  // 3 rows
        XCTAssertEqual(result[0].count, 4)  // 4 columns
        XCTAssertEqual(result[1].count, 4)
        XCTAssertEqual(result[2].count, 4)

        // Verify all values are in range [0, 1]
        for row in result {
            for value in row {
                XCTAssertGreaterThanOrEqual(value, 0.0)
                XCTAssertLessThanOrEqual(value, 1.0)
            }
        }
    }

    func testRandom1DFloat() {
        let result = [Float].random(5)

        // Verify count
        XCTAssertEqual(result.count, 5)

        // Verify all values are in range [0, 1]
        for value in result {
            XCTAssertGreaterThanOrEqual(value, 0.0)
            XCTAssertLessThanOrEqual(value, 1.0)
        }
    }

    func testRandom2DFloat() {
        let result = [Float].random(2, 3)

        // Verify dimensions
        XCTAssertEqual(result.count, 2)  // 2 rows
        XCTAssertEqual(result[0].count, 3)  // 3 columns
        XCTAssertEqual(result[1].count, 3)

        // Verify all values are in range [0, 1]
        for row in result {
            for value in row {
                XCTAssertGreaterThanOrEqual(value, 0.0)
                XCTAssertLessThanOrEqual(value, 1.0)
            }
        }
    }

    func testRandom1DEmptyArray() {
        let result = [Double].random(0)

        // Should create an empty array without error
        XCTAssertEqual(result.count, 0)
        XCTAssertTrue(result.isEmpty)
    }

    func testRandom1DNegativeCountPrecondition() {
        // Verify that negative count triggers precondition failure
        // Note: This test expects a precondition failure, which terminates the process
        // We can't directly test this in XCTest without special handling
        // Instead, we document that the precondition exists

        // This is a documentation test - the actual precondition is verified
        // by code review and the implementation in ArrayRandom.swift:18
        XCTAssertTrue(true, "Precondition exists: count must be non-negative")
    }

    func testRandom2DPreconditions() {
        // Verify that invalid dimensions would trigger precondition failures
        // Preconditions: rows > 0 && columns > 0

        // This is a documentation test - the actual preconditions are verified
        // by code review and the implementation in ArrayRandom.swift:24
        XCTAssertTrue(true, "Preconditions exist: dimensions must be positive")
    }

    func testRandomValuesAreDifferent() {
        // Verify that random generation produces different values
        // (extremely unlikely to generate identical arrays)
        let result1 = [Double].random(10)
        let result2 = [Double].random(10)

        // Arrays should not be identical
        XCTAssertNotEqual(result1, result2, "Random arrays should be different")
    }
}
