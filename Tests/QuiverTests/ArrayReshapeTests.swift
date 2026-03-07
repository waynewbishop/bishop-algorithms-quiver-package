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

final class ArrayReshapeTests: XCTestCase {

    // Reshape a 1D vector into a 2D matrix
    func testReshaped1Dto2D() {
        let vector = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        let matrix = vector.reshaped(rows: 2, columns: 3)

        XCTAssertEqual(matrix, [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ])
    }

    // Reshape a 2D matrix into different 2D dimensions
    func testReshaped2Dto2D() {
        let matrix: [[Double]] = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ]
        let reshaped = matrix.reshaped(rows: 3, columns: 2)

        XCTAssertEqual(reshaped, [
            [1.0, 2.0],
            [3.0, 4.0],
            [5.0, 6.0]
        ])
    }

    // Flatten a 2D matrix into a 1D vector
    func testFlattened() {
        let matrix: [[Double]] = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ]
        let flat = matrix.flattened()

        XCTAssertEqual(flat, [1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
    }

    // Flatten then reshape returns the original matrix
    func testReshapeRoundTrip() {
        let original: [[Double]] = [
            [10.0, 20.0, 30.0],
            [40.0, 50.0, 60.0]
        ]
        let roundTrip = original.flattened().reshaped(rows: 2, columns: 3)

        XCTAssertEqual(roundTrip, original)
    }

    // Reshape to a single-row matrix
    func testReshapeToSingleRow() {
        let vector = [1.0, 2.0, 3.0, 4.0]
        let row = vector.reshaped(rows: 1, columns: 4)

        XCTAssertEqual(row, [[1.0, 2.0, 3.0, 4.0]])
    }

    // Reshape to a single-column matrix
    func testReshapeToSingleColumn() {
        let vector = [1.0, 2.0, 3.0, 4.0]
        let column = vector.reshaped(rows: 4, columns: 1)

        XCTAssertEqual(column, [[1.0], [2.0], [3.0], [4.0]])
    }

    // Flatten an empty matrix
    func testFlattenedEmpty() {
        let empty: [[Double]] = []
        let flat = empty.flattened()

        XCTAssertEqual(flat, [])
    }

    // Reshape with Float type
    func testReshapeWithFloat() {
        let vector: [Float] = [1.0, 2.0, 3.0, 4.0]
        let matrix = vector.reshaped(rows: 2, columns: 2)

        XCTAssertEqual(matrix, [
            [Float(1.0), Float(2.0)],
            [Float(3.0), Float(4.0)]
        ])
    }
}
