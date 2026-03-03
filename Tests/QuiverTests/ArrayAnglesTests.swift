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

final class ArrayAnglesTests: XCTestCase {

    func testAngle() {
        let v1 = [1.0, 0.0]
        let v2 = [0.0, 1.0]
        let angle = v1.angle(with: v2)
        XCTAssertEqual(angle, Double.pi/2, accuracy: 1e-10)
    }

    func testAngleInDegrees() {
        let v1 = [1.0, 0.0]
        let v2 = [0.0, 1.0]
        let angle = v1.angleInDegrees(with: v2)
        XCTAssertEqual(angle, 90.0, accuracy: 1e-10)
    }
}
