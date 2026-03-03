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

final class ArrayBroadcastTests: XCTestCase {

    // MARK: - Scalar Broadcasting Tests

    func testBroadcastAddingScalar() {
        let array = [1.0, 2.0, 3.0]
        XCTAssertEqual(array.broadcast(adding: 5.0), [6.0, 7.0, 8.0])
    }

    func testBroadcastMultiplyingByScalar() {
        let array = [1.0, 2.0, 3.0]
        XCTAssertEqual(array.broadcast(multiplyingBy: 2.0), [2.0, 4.0, 6.0])
    }

    func testBroadcastSubtractingScalar() {
        let array = [5.0, 7.0, 9.0]
        XCTAssertEqual(array.broadcast(subtracting: 2.0), [3.0, 5.0, 7.0])
    }

    func testBroadcastDividingByScalar() {
        let array = [2.0, 4.0, 6.0]
        XCTAssertEqual(array.broadcast(dividingBy: 2.0), [1.0, 2.0, 3.0])
    }

    func testBroadcastWithEmptyArray() {
        let emptyArray: [Double] = []
        XCTAssertEqual(emptyArray.broadcast(adding: 5.0), [])
        XCTAssertEqual(emptyArray.broadcast(multiplyingBy: 2.0), [])
        XCTAssertEqual(emptyArray.broadcast(subtracting: 1.0), [])
        XCTAssertEqual(emptyArray.broadcast(dividingBy: 2.0), [])
    }

    // MARK: - Matrix-Vector Broadcasting Tests

    func testBroadcastAddingToEachRow() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let rowVector = [10.0, 20.0, 30.0]

        let result = matrix.broadcast(addingToEachRow: rowVector)
        XCTAssertEqual(result, [[11.0, 22.0, 33.0], [14.0, 25.0, 36.0]])
    }

    func testBroadcastAddingToEachColumn() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let columnVector = [10.0, 20.0]

        let result = matrix.broadcast(addingToEachColumn: columnVector)
        XCTAssertEqual(result, [[11.0, 12.0, 13.0], [24.0, 25.0, 26.0]])
    }

    func testBroadcastMultiplyingEachRowBy() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let rowVector = [10.0, 20.0, 30.0]

        let result = matrix.broadcast(multiplyingEachRowBy: rowVector)
        XCTAssertEqual(result, [[10.0, 40.0, 90.0], [40.0, 100.0, 180.0]])
    }

    func testBroadcastMultiplyingEachColumnBy() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let columnVector = [10.0, 20.0]

        let result = matrix.broadcast(multiplyingEachColumnBy: columnVector)
        XCTAssertEqual(result, [[10.0, 20.0, 30.0], [80.0, 100.0, 120.0]])
    }

    // MARK: - Custom Broadcasting Tests

    func testBroadcastWithCustomOperation() {
        let array = [1.0, 2.0, 3.0]
        let result = array.broadcast(with: 2.0) { base, exponent in
            pow(base, exponent)
        }
        XCTAssertEqual(result, [1.0, 4.0, 9.0])
    }

    func testBroadcastWithRowVectorCustomOperation() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let rowVector = [10.0, 20.0, 30.0]

        let result = matrix.broadcast(withRowVector: rowVector) { matrixElement, vectorElement in
            matrixElement / vectorElement
        }
        XCTAssertEqual(result, [[0.1, 0.1, 0.1], [0.4, 0.25, 0.2]])
    }

    func testBroadcastWithColumnVectorCustomOperation() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let columnVector = [10.0, 20.0]

        let result = matrix.broadcast(withColumnVector: columnVector) { matrixElement, vectorElement in
            (matrixElement + vectorElement) * 2.0
        }
        XCTAssertEqual(result, [[22.0, 24.0, 26.0], [48.0, 50.0, 52.0]])
    }

    // MARK: - Complex Broadcast Combinations

    func testComplexBroadcastOperation() {
        let array = [1.0, 2.0, 3.0, 4.0, 5.0]

        let result = array
            .broadcast(multiplyingBy: 2.0)
            .broadcast(adding: 1.0)
            .broadcast(dividingBy: 2.0)

        XCTAssertEqual(result, [1.5, 2.5, 3.5, 4.5, 5.5])
    }

    func testMatrixComplexBroadcastOperation() {
        let matrix = [[1.0, 2.0], [3.0, 4.0]]
        let rowVector = [10.0, 20.0]
        let columnVector = [100.0, 200.0]

        let intermediate = matrix.broadcast(addingToEachRow: rowVector)
        let result = intermediate.broadcast(multiplyingEachColumnBy: columnVector)

        XCTAssertEqual(result, [[1100.0, 2200.0], [2600.0, 4800.0]])
    }
}
