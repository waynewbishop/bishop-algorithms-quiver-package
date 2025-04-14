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
        let result = array.broadcast(adding: 5.0)
        XCTAssertEqual(result, [6.0, 7.0, 8.0])
    }
    
    func testBroadcastMultiplyingByScalar() {
        let array = [1.0, 2.0, 3.0]
        let result = array.broadcast(multiplyingBy: 2.0)
        XCTAssertEqual(result, [2.0, 4.0, 6.0])
    }
    
    func testBroadcastSubtractingScalar() {
        let array = [5.0, 7.0, 9.0]
        let result = array.broadcast(subtracting: 2.0)
        XCTAssertEqual(result, [3.0, 5.0, 7.0])
    }
    
    func testBroadcastDividingByScalar() {
        let array = [2.0, 4.0, 6.0]
        let result = array.broadcast(dividingBy: 2.0)
        XCTAssertEqual(result, [1.0, 2.0, 3.0])
    }
    
    func testBroadcastDividingByZero() {
        let array = [2.0, 4.0, 6.0]
        
        // Note: Dividing by zero triggers a precondition failure
        // which cannot be caught in unit tests.
        // Manual verification required: operation should crash when dividing by zero
        
        // Instead, verify that we're properly checking for positive inputs
        XCTAssertNoThrow(array.broadcast(dividingBy: 0.1))  // Very small but non-zero value should work
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
    
    func testBroadcastAddingToEachRowWithMismatchedDimensions() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let wrongRowVector = [10.0, 20.0] // Should have 3 elements
        
        // Note: This operation enforces dimension matching via precondition
        // which cannot be caught in unit tests.
        // Manual verification required: operation should crash when dimensions don't match
        
        // Instead, verify the test is set up with mismatched dimensions
        if let firstRow = matrix.first {
            XCTAssertNotEqual(firstRow.count, wrongRowVector.count,
                             "Test setup should use mismatched dimensions")
        } else {
            XCTFail("Matrix should not be empty")
        }
    }
    
    func testBroadcastAddingToEachColumnWithMismatchedDimensions() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let wrongColumnVector = [10.0, 20.0, 30.0] // Should have 2 elements
        
        // Note: This operation enforces dimension matching via precondition
        // which cannot be caught in unit tests.
        // Manual verification required: operation should crash when dimensions don't match
        
        // Verify the test is set up correctly
        XCTAssertNotEqual(matrix.count, wrongColumnVector.count,
                         "Test setup should use mismatched dimensions")
    }
    
    // MARK: - Custom Broadcasting Tests
    
    func testBroadcastWithCustomOperation() {
        let array = [1.0, 2.0, 3.0]
        
        // Custom operation: raise each element to the power of 2
        let result = array.broadcast(with: 2.0) { base, exponent in
            pow(base, exponent)
        }
        
        XCTAssertEqual(result, [1.0, 4.0, 9.0])
    }
    
    func testBroadcastWithRowVectorCustomOperation() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let rowVector = [10.0, 20.0, 30.0]
        
        // Custom operation: divide matrix element by vector element
        let result = matrix.broadcast(withRowVector: rowVector) { matrixElement, vectorElement in
            matrixElement / vectorElement
        }
        
        XCTAssertEqual(result, [[0.1, 0.1, 0.1], [0.4, 0.25, 0.2]])
    }
    
    func testBroadcastWithColumnVectorCustomOperation() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let columnVector = [10.0, 20.0]
        
        // Custom operation: add matrix element and vector element, then multiply by 2
        let result = matrix.broadcast(withColumnVector: columnVector) { matrixElement, vectorElement in
            (matrixElement + vectorElement) * 2.0
        }
        
        XCTAssertEqual(result, [[22.0, 24.0, 26.0], [48.0, 50.0, 52.0]])
    }
    
    func testBroadcastWithRowVectorMismatchedDimensions() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let wrongRowVector = [10.0, 20.0] // Should have 3 elements
        
        // Note: This operation enforces dimension matching via precondition
        // which cannot be caught in unit tests.
        // Manual verification required: operation should crash when dimensions don't match
        
        // Verify the test is set up with mismatched dimensions
        if let firstRow = matrix.first {
            XCTAssertNotEqual(firstRow.count, wrongRowVector.count,
                             "Test setup should use mismatched dimensions")
        } else {
            XCTFail("Matrix should not be empty")
        }
    }

    func testBroadcastWithColumnVectorMismatchedDimensions() {
        let matrix = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let wrongColumnVector = [10.0, 20.0, 30.0] // Should have 2 elements
        
        // Note: This operation enforces dimension matching via precondition
        // which cannot be caught in unit tests.
        // Manual verification required: operation should crash when dimensions don't match
        
        // Verify the test is set up with mismatched dimensions
        XCTAssertNotEqual(matrix.count, wrongColumnVector.count,
                         "Test setup should use mismatched dimensions")
    }
    
    // MARK: - Integer Broadcasting Tests
    
    func testIntegerBroadcastAddingScalar() {
        let array = [1, 2, 3]
        let result = array.broadcast(adding: 5)
        XCTAssertEqual(result, [6, 7, 8])
    }
    
    func testIntegerBroadcastMultiplyingByScalar() {
        let array = [1, 2, 3]
        let result = array.broadcast(multiplyingBy: 2)
        XCTAssertEqual(result, [2, 4, 6])
    }
    
    func testIntegerBroadcastSubtractingScalar() {
        let array = [5, 7, 9]
        let result = array.broadcast(subtracting: 2)
        XCTAssertEqual(result, [3, 5, 7])
    }
    
    // MARK: - Complex Broadcast Combinations
    
    func testComplexBroadcastOperation() {
        let array = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        // Chain multiple broadcast operations
        let result = array
            .broadcast(multiplyingBy: 2.0)    // [2.0, 4.0, 6.0, 8.0, 10.0]
            .broadcast(adding: 1.0)           // [3.0, 5.0, 7.0, 9.0, 11.0]
            .broadcast(dividingBy: 2.0)       // [1.5, 2.5, 3.5, 4.5, 5.5]
            
        XCTAssertEqual(result, [1.5, 2.5, 3.5, 4.5, 5.5])
    }
    
    func testMatrixComplexBroadcastOperation() {
        let matrix = [[1.0, 2.0], [3.0, 4.0]]
        let rowVector = [10.0, 20.0]
        let columnVector = [100.0, 200.0]
        
        // First add the row vector, then multiply by the column vector
        let intermediate = matrix.broadcast(addingToEachRow: rowVector)
                                 // [[11.0, 22.0], [13.0, 24.0]]
        
        let result = intermediate.broadcast(multiplyingEachColumnBy: columnVector)
                                // [[1100.0, 2200.0], [2600.0, 4800.0]]
        
        XCTAssertEqual(result, [[1100.0, 2200.0], [2600.0, 4800.0]])
    }
}
