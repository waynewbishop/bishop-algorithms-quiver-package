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

final class ArrayDimensionsTests: XCTestCase {

    // Shape returns correct rows and columns for various matrix layouts
    func testShape() {
        let standard: [[Double]] = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        XCTAssertEqual(standard.shape.rows, 2)
        XCTAssertEqual(standard.shape.columns, 3)

        let singleRow: [[Double]] = [[1.0, 2.0, 3.0]]
        XCTAssertEqual(singleRow.shape.rows, 1)
        XCTAssertEqual(singleRow.shape.columns, 3)

        let singleColumn: [[Double]] = [[1.0], [2.0], [3.0]]
        XCTAssertEqual(singleColumn.shape.rows, 3)
        XCTAssertEqual(singleColumn.shape.columns, 1)
    }

    // Size returns the total element count across all dimensions
    func testSize() {
        let matrix: [[Double]] = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        XCTAssertEqual(matrix.size, 6)
        XCTAssertEqual(matrix.count, 2)

        let single: [[Double]] = [[42.0]]
        XCTAssertEqual(single.size, 1)
    }

    // Shape and size handle empty matrices
    func testEmptyMatrix() {
        let empty: [[Double]] = []
        XCTAssertEqual(empty.shape.rows, 0)
        XCTAssertEqual(empty.shape.columns, 0)
        XCTAssertEqual(empty.size, 0)
    }

    // Shape and size work with Float and Int types
    func testNumericTypes() {
        let floats: [[Float]] = [[1.0, 2.0], [3.0, 4.0]]
        XCTAssertEqual(floats.shape.rows, 2)
        XCTAssertEqual(floats.size, 4)

        let ints: [[Int]] = [[1, 2, 3], [4, 5, 6]]
        XCTAssertEqual(ints.shape.columns, 3)
        XCTAssertEqual(ints.size, 6)
    }

    // Shape and size are consistent after reshape
    func testShapeAfterReshape() {
        let vector = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        let matrix = vector.reshaped(rows: 2, columns: 3)
        XCTAssertEqual(matrix.shape.rows, 2)
        XCTAssertEqual(matrix.shape.columns, 3)
        XCTAssertEqual(matrix.size, 6)
    }
}
