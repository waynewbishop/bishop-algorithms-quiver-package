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
    
    func testDistance() {
        // Test classic 3-4-5 triangle
        let v1 = [0.0, 0.0]
        let v2 = [3.0, 4.0]
        let result = v1.distance(to: v2)
        XCTAssertEqual(result, 5.0)
    }

    func testDistanceSymmetric() {
        // Distance should be the same regardless of direction
        let pointA = [1.0, 2.0, 3.0]
        let pointB = [4.0, 6.0, 8.0]
                
        let distanceAB = pointA.distance(to: pointB)
        let distanceBA = pointB.distance(to: pointA)
        
        XCTAssertEqual(distanceAB, distanceBA, accuracy: 1e-10)
    }

    func testDistanceToSelf() {
        // Distance from a point to itself should be zero
        let point = [5.0, 10.0, 15.0]
        let result = point.distance(to: point)
        XCTAssertEqual(result, 0.0)
    }
    
    func testCosineOfAnglePerpendicularVectors() {
        let v1 = [1.0, 0.0]
        let v2 = [0.0, 1.0]
        let cosine = v1.cosineOfAngle(with: v2)
        XCTAssertEqual(cosine, 0.0, accuracy: 1e-10)
    }
        
    func testCosineOfAngleParallelVectors() {
        let v1 = [3.0, 4.0]
        let v2 = [6.0, 8.0]
        let cosine = v1.cosineOfAngle(with: v2)
        XCTAssertEqual(cosine, 1.0, accuracy: 1e-10)
    }
    
    func testCosineOfAngle45Degrees() {
        let v1 = [1.0, 0.0]
        let v2 = [1.0, 1.0]
        let cosine = v1.cosineOfAngle(with: v2)
        XCTAssertEqual(cosine, 1.0/sqrt(2.0), accuracy: 1e-10)
    }
    
    func testCosineSimilaritiesDouble() {
        // Test with two known vectors
        let vectors = [
            [1.0, 0.0],      // Along x-axis
            [0.0, 1.0]       // Along y-axis (perpendicular)
        ]
        let target = [1.0, 0.0]  // x-axis vector
        
        let similarities = vectors.cosineSimilarities(to: target)
        
        XCTAssertEqual(similarities[0], 1.0, accuracy: 1e-10)  // Identical vectors
        XCTAssertEqual(similarities[1], 0.0, accuracy: 1e-10)  // Perpendicular vectors
    }
        
    func testCosineSimilaritiesDoubleWithEmptyArray() {
        let emptyVectors: [[Double]] = []
        let target = [1.0, 2.0, 3.0]
        
        let similarities = emptyVectors.cosineSimilarities(to: target)
        
        XCTAssertTrue(similarities.isEmpty)
    }
        
    // MARK: - Float Vector Tests
    
    func testCosineSimilaritiesFloat() {
        // Test with two known vectors
        let vectors: [[Float]] = [
            [1.0, 0.0],      // Along x-axis
            [1.0, 1.0]       // 45° angle
        ]
        let target: [Float] = [1.0, 0.0]  // x-axis vector
        
        let similarity_score = vectors.cosineSimilarities(to: target)
        
        XCTAssertEqual(similarity_score[0], 1.0, accuracy: 1e-6)  // Identical vectors
        XCTAssertEqual(similarity_score[1], 1.0/sqrt(2.0), accuracy: 1e-6)  // 45° angle
    }
        
    func testCosineSimilaritiesFloatWithSingleVector() {
        let vectors: [[Float]] = [[3.0, 4.0]]  // Single vector with magnitude 5
        let target: [Float] = [6.0, 8.0]       // Same direction, magnitude 10
        
        let similarity_score = vectors.cosineSimilarities(to: target)
        
        XCTAssertEqual(similarity_score.count, 1)
        XCTAssertEqual(similarity_score[0], 1.0, accuracy: 1e-6)  // Same direction = similarity of 1.0
    }
    
    func testAveraged() {
        let vectors = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
            [7.0, 8.0, 9.0]
        ]
        let result = vectors.averaged()
        XCTAssertEqual(result, [4.0, 5.0, 6.0])
    }

    func testAveragedWithInvalidDimensions() {
        let vectors = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0],        // Different dimension
            [7.0, 8.0, 9.0]
        ]
        let result = vectors.averaged()
        XCTAssertNil(result)
    }

    func testAveragedWithEmptyArray() {
        let vectors: [[Double]] = []
        let result = vectors.averaged()
        XCTAssertNil(result)
    }

    func testAveragedWithSingleVector() {
        let vectors = [[3.0, 4.0, 5.0]]
        let result = vectors.averaged()
        XCTAssertEqual(result, [3.0, 4.0, 5.0])
    }
}
