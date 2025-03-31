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

//TODO: These are just basic tests. Organize new tests based on functional areas
//keep the tests as simple (but correct) as possible for educational purposes.

final class VectorOperationsTests: XCTestCase {
    
    func testAddition() {
        let v1: [Double] = [1.0, 2.0, 3.0]
        let v2: [Double] = [4.0, 5.0, 6.0]
        let result = v1 + v2
        XCTAssertEqual(result, [5.0, 7.0, 9.0])
    }
    
    func testDotProduct() {
        let v1: [Double] = [1.0, 2.0, 3.0]
        let v2: [Double] = [4.0, 5.0, 6.0]
        let result = v1.dot(v2)
        XCTAssertEqual(result, 32.0) // 1*4 + 2*5 + 3*6 = 32
    }
    
    func testMagnitude() {
        let v: [Double] = [3.0, 4.0]
        XCTAssertEqual(v.magnitude, 5.0)
    }
    
    // Add more tests as needed
}
