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

final class ArrayGenerationTests: XCTestCase {
    
    func testZeros() {
        let result = [Double].zeros(3)
        XCTAssertEqual(result, [0.0, 0.0, 0.0])
    }
    
    func testOnes() {
        let result = [Double].ones(3)
        XCTAssertEqual(result, [1.0, 1.0, 1.0])
    }
    
    func testFull() {
        let result = [Double].full(3, value: 7.5)
        XCTAssertEqual(result, [7.5, 7.5, 7.5])
    }
    
    func testZeros2D() {
        let result = [Int].zeros(2, 3)
        XCTAssertEqual(result, [[0, 0, 0], [0, 0, 0]])
    }
    
    func testOnes2D() {
        let result = [Int].ones(2, 2)
        XCTAssertEqual(result, [[1, 1], [1, 1]])
    }
    
    func testFull2D() {
        let result = [Int].full(2, 2, value: 7)
        XCTAssertEqual(result, [[7, 7], [7, 7]])
    }
    
   
    
    func testDiag() {
        let diagonal = [1.0, 2.0, 3.0]
        let result = [Double].diag(diagonal)
        XCTAssertEqual(result, [[1.0, 0.0, 0.0], [0.0, 2.0, 0.0], [0.0, 0.0, 3.0]])
    }
    
    func testLinspace() {
        let result = [Double].linspace(0, 10, num: 5)
        XCTAssertEqual(result, [0.0, 2.5, 5.0, 7.5, 10.0])
    }
    
    func testArange() {
        let result = [Double].arange(0, 10, step: 2.5)
        XCTAssertEqual(result, [0.0, 2.5, 5.0, 7.5])
    }
}
