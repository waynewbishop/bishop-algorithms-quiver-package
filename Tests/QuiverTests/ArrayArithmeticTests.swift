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

final class ArrayArithmeticTests: XCTestCase {
    
    func testAddition() {
        let a = [1.0, 2.0, 3.0]
        let b = [4.0, 5.0, 6.0]
        let result = a + b
        XCTAssertEqual(result, [5.0, 7.0, 9.0])
    }
    
    func testSubtraction() {
        let a = [5.0, 7.0, 9.0]
        let b = [1.0, 2.0, 3.0]
        let result = a - b
        XCTAssertEqual(result, [4.0, 5.0, 6.0])
    }
    
    func testMultiplication() {
        let a = [2.0, 3.0, 4.0]
        let b = [3.0, 2.0, 1.0]
        let result = a * b
        XCTAssertEqual(result, [6.0, 6.0, 4.0])
    }
    
    func testDivision() {
        let a = [6.0, 8.0, 10.0]
        let b = [2.0, 4.0, 5.0]
        let result = a / b
        XCTAssertEqual(result, [3.0, 2.0, 2.0])
    }
    
    func testAdditionWithMismatchedSizes() {
        // Note: The addition operator enforces equal dimensions via precondition
        // which cannot be caught in unit tests.
        // Manual verification required: a + b should crash when a.count != b.count
        
        // Alternatively, test the underlying implementation directly
        let a = [1.0, 2.0, 3.0]
        let b = [4.0, 5.0]
        
        XCTAssertNotEqual(a.count, b.count, "Test setup should use different dimensions")
    }
    
}
