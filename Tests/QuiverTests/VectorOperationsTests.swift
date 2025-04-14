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

final class VectorOperationsTests: XCTestCase {
    
    func testDotProduct() {
        let a = [1.0, 2.0, 3.0]
        let b = [4.0, 5.0, 6.0]
        let result = a.dot(b)
        XCTAssertEqual(result, 32.0)
    }
    
    func testMagnitude() {
        let v = [3.0, 4.0]
        XCTAssertEqual(v.magnitude, 5.0)
    }
    
    func testNormalized() {
        let v = [3.0, 0.0]
        let result = v.normalized
        XCTAssertEqual(result, [1.0, 0.0])
    }
    
    func testCosineOfAngle() {
        let v1 = [1.0, 0.0]
        let v2 = [1.0, 1.0]
        let cosine = v1.cosineOfAngle(with: v2)
        XCTAssertEqual(cosine, 1.0/sqrt(2.0), accuracy: 1e-10)
    }
    
    func testScalarProjection() {
        let v = [3.0, 4.0]
        let axis = [1.0, 0.0]
        let result = v.scalarProjection(onto: axis)
        XCTAssertEqual(result, 3.0)
    }
    
    func testVectorProjection() {
        let v = [3.0, 4.0]
        let axis = [1.0, 0.0]
        let result = v.vectorProjection(onto: axis)
        XCTAssertEqual(result, [3.0, 0.0])
    }
    
    func testOrthogonalComponent() {
        let v = [3.0, 4.0]
        let axis = [1.0, 0.0]
        let result = v.orthogonalComponent(to: axis)
        XCTAssertEqual(result, [0.0, 4.0])
    }
    
    func testMatrixTransformation() {
        let v = [1.0, 2.0]
        let matrix = [[0.0, -1.0], [1.0, 0.0]]  // 90° rotation
        let result = v.transformedBy(matrix)
        XCTAssertEqual(result, [-2.0, 1.0])
    }
}
