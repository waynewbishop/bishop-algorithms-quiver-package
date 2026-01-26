// Copyright 2025 Wayne W Bishop. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import XCTest
@testable import Quiver

final class MatrixArithmeticTests: XCTestCase {

    // MARK: - Matrix Addition Tests

    func testMatrixAddition() {
        let m1 = [[1.0, 2.0], [3.0, 4.0]]
        let m2 = [[5.0, 6.0], [7.0, 8.0]]
        let result = m1 + m2

        XCTAssertEqual(result, [[6.0, 8.0], [10.0, 12.0]])
    }

    func testMatrixAdditionFloat() {
        let m1: [[Float]] = [[1.0, 2.0], [3.0, 4.0]]
        let m2: [[Float]] = [[5.0, 6.0], [7.0, 8.0]]
        let result = m1 + m2

        XCTAssertEqual(result, [[6.0, 8.0], [10.0, 12.0]])
    }

    // MARK: - Matrix Subtraction Tests

    func testMatrixSubtraction() {
        let m1 = [[5.0, 7.0], [9.0, 11.0]]
        let m2 = [[1.0, 2.0], [3.0, 4.0]]
        let result = m1 - m2

        XCTAssertEqual(result, [[4.0, 5.0], [6.0, 7.0]])
    }

    func testMatrixSubtractionFloat() {
        let m1: [[Float]] = [[5.0, 7.0], [9.0, 11.0]]
        let m2: [[Float]] = [[1.0, 2.0], [3.0, 4.0]]
        let result = m1 - m2

        XCTAssertEqual(result, [[4.0, 5.0], [6.0, 7.0]])
    }

    // MARK: - Matrix Multiplication (Element-wise) Tests

    func testMatrixMultiplication() {
        let m1 = [[2.0, 3.0], [4.0, 5.0]]
        let m2 = [[3.0, 2.0], [1.0, 2.0]]
        let result = m1 * m2

        XCTAssertEqual(result, [[6.0, 6.0], [4.0, 10.0]])
    }

    func testMatrixMultiplicationFloat() {
        let m1: [[Float]] = [[2.0, 3.0], [4.0, 5.0]]
        let m2: [[Float]] = [[3.0, 2.0], [1.0, 2.0]]
        let result = m1 * m2

        XCTAssertEqual(result, [[6.0, 6.0], [4.0, 10.0]])
    }

    // MARK: - Matrix Division Tests

    func testMatrixDivision() {
        let m1 = [[6.0, 8.0], [10.0, 12.0]]
        let m2 = [[2.0, 4.0], [5.0, 3.0]]
        let result = m1 / m2

        XCTAssertEqual(result, [[3.0, 2.0], [2.0, 4.0]])
    }

    func testMatrixDivisionFloat() {
        let m1: [[Float]] = [[6.0, 8.0], [10.0, 12.0]]
        let m2: [[Float]] = [[2.0, 4.0], [5.0, 3.0]]
        let result = m1 / m2

        XCTAssertEqual(result, [[3.0, 2.0], [2.0, 4.0]])
    }

    // MARK: - Scalar Broadcasting Tests (Matrix + Scalar)

    func testMatrixPlusScalar() {
        let matrix = [[1.0, 2.0], [3.0, 4.0]]
        let result = matrix + 10.0

        XCTAssertEqual(result, [[11.0, 12.0], [13.0, 14.0]])
    }

    func testScalarPlusMatrix() {
        let matrix = [[1.0, 2.0], [3.0, 4.0]]
        let result = 10.0 + matrix

        XCTAssertEqual(result, [[11.0, 12.0], [13.0, 14.0]])
    }

    func testMatrixMinusScalar() {
        let matrix = [[11.0, 12.0], [13.0, 14.0]]
        let result = matrix - 10.0

        XCTAssertEqual(result, [[1.0, 2.0], [3.0, 4.0]])
    }

    func testScalarMinusMatrix() {
        let matrix = [[1.0, 2.0], [3.0, 4.0]]
        let result = 10.0 - matrix

        XCTAssertEqual(result, [[9.0, 8.0], [7.0, 6.0]])
    }

    func testMatrixTimesScalar() {
        let matrix = [[2.0, 3.0], [4.0, 5.0]]
        let result = matrix * 2.0

        XCTAssertEqual(result, [[4.0, 6.0], [8.0, 10.0]])
    }

    func testScalarTimesMatrix() {
        let matrix = [[2.0, 3.0], [4.0, 5.0]]
        let result = 2.0 * matrix

        XCTAssertEqual(result, [[4.0, 6.0], [8.0, 10.0]])
    }

    func testMatrixDividedByScalar() {
        let matrix = [[4.0, 6.0], [8.0, 10.0]]
        let result = matrix / 2.0

        XCTAssertEqual(result, [[2.0, 3.0], [4.0, 5.0]])
    }

    func testScalarDividedByMatrix() {
        let matrix = [[2.0, 4.0], [5.0, 10.0]]
        let result = 20.0 / matrix

        XCTAssertEqual(result, [[10.0, 5.0], [4.0, 2.0]])
    }

    // MARK: - Scalar Broadcasting Tests (Float)

    func testMatrixPlusScalarFloat() {
        let matrix: [[Float]] = [[1.0, 2.0], [3.0, 4.0]]
        let result = matrix + 10.0

        XCTAssertEqual(result, [[11.0, 12.0], [13.0, 14.0]])
    }

    func testScalarPlusMatrixFloat() {
        let matrix: [[Float]] = [[1.0, 2.0], [3.0, 4.0]]
        let result: [[Float]] = 10.0 + matrix

        XCTAssertEqual(result, [[11.0, 12.0], [13.0, 14.0]])
    }

    // MARK: - Real-World Use Cases

    func testSensorReadingsCombination() {
        let readings1 = [[1.0, 2.0], [3.0, 4.0]]
        let readings2 = [[0.5, 0.3], [0.7, 0.2]]
        let combined = readings1 + readings2

        XCTAssertEqual(combined, [[1.5, 2.3], [3.7, 4.2]])
    }

    func testDataNormalization() {
        let data = [[100.0, 200.0], [300.0, 400.0]]
        let normalized = (data - 250.0) / 150.0

        // Expected: ((value - mean) / stddev)
        let expected = [[-1.0, -1.0/3.0], [1.0/3.0, 1.0]]

        // Compare with tolerance for floating point
        XCTAssertEqual(normalized[0][0], expected[0][0], accuracy: 0.0001)
        XCTAssertEqual(normalized[0][1], expected[0][1], accuracy: 0.0001)
        XCTAssertEqual(normalized[1][0], expected[1][0], accuracy: 0.0001)
        XCTAssertEqual(normalized[1][1], expected[1][1], accuracy: 0.0001)
    }

    func testFeatureScaling() {
        let features = [[2.0, 4.0], [6.0, 8.0]]
        let scaled = features * 0.5

        XCTAssertEqual(scaled, [[1.0, 2.0], [3.0, 4.0]])
    }

    // MARK: - Vector Scalar Broadcasting Tests

    func testVectorPlusScalar() {
        let vector = [1.0, 2.0, 3.0]
        let result = vector + 10.0

        XCTAssertEqual(result, [11.0, 12.0, 13.0])
    }

    func testScalarPlusVector() {
        let vector = [1.0, 2.0, 3.0]
        let result = 10.0 + vector

        XCTAssertEqual(result, [11.0, 12.0, 13.0])
    }

    func testVectorMinusScalar() {
        let vector = [11.0, 12.0, 13.0]
        let result = vector - 10.0

        XCTAssertEqual(result, [1.0, 2.0, 3.0])
    }

    func testScalarMinusVector() {
        let vector = [1.0, 2.0, 3.0]
        let result = 10.0 - vector

        XCTAssertEqual(result, [9.0, 8.0, 7.0])
    }

    func testVectorTimesScalar() {
        let vector = [2.0, 3.0, 4.0]
        let result = vector * 2.0

        XCTAssertEqual(result, [4.0, 6.0, 8.0])
    }

    func testScalarTimesVector() {
        let vector = [2.0, 3.0, 4.0]
        let result = 2.0 * vector

        XCTAssertEqual(result, [4.0, 6.0, 8.0])
    }

    func testVectorDividedByScalar() {
        let vector = [4.0, 6.0, 8.0]
        let result = vector / 2.0

        XCTAssertEqual(result, [2.0, 3.0, 4.0])
    }

    func testScalarDividedByVector() {
        let vector = [2.0, 4.0, 5.0]
        let result = 20.0 / vector

        XCTAssertEqual(result, [10.0, 5.0, 4.0])
    }
}
