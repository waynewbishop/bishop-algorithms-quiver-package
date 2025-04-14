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

final class ArrayBooleanTests: XCTestCase {
    
    func testIsEqual() {
        let a = [1, 2, 3, 4]
        let b = [1, 3, 3, 5]
        XCTAssertEqual(a.isEqual(to: b), [true, false, true, false])
    }
    
    func testIsGreaterThan() {
        let a = [1, 5, 3, 7]
        XCTAssertEqual(a.isGreaterThan(4), [false, true, false, true])
    }
    
    func testIsLessThan() {
        let a = [1, 5, 3, 7]
        XCTAssertEqual(a.isLessThan(4), [true, false, true, false])
    }
    
    func testIsGreaterThanOrEqual() {
        let a = [1, 4, 3, 7]
        XCTAssertEqual(a.isGreaterThanOrEqual(4), [false, true, false, true])
    }
    
    func testIsLessThanOrEqual() {
        let a = [1, 4, 3, 7]
        XCTAssertEqual(a.isLessThanOrEqual(4), [true, true, true, false])
    }
    
    func testAnd() {
        let a = [true, true, false, false]
        let b = [true, false, true, false]
        XCTAssertEqual(a.and(b), [true, false, false, false])
    }
    
    func testOr() {
        let a = [true, true, false, false]
        let b = [true, false, true, false]
        XCTAssertEqual(a.or(b), [true, true, true, false])
    }
    
    func testNot() {
        let a = [true, false, true]
        XCTAssertEqual(a.not, [false, true, false])
    }
    
    func testTrueIndices() {
        let a = [false, true, false, true, true]
        XCTAssertEqual(a.trueIndices, [1, 3, 4])
    }
    
    func testMasked() {
        let values = [1, 2, 3, 4, 5]
        let mask = [true, false, true, false, true]
        XCTAssertEqual(values.masked(by: mask), [1, 3, 5])
    }
    
    func testChoose() {
        let a = [1, 2, 3, 4, 5]
        let condition = [true, false, true, false, true]
        let b = [10, 20, 30, 40, 50]
        XCTAssertEqual(a.choose(where: condition, otherwise: b), [1, 20, 3, 40, 5])
    }
}
