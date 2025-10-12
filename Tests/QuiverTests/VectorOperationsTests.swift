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

    func testAveragedWithTwoVectors() {
        let vectors = [
            [2.0, 4.0, 6.0],
            [8.0, 6.0, 4.0]
        ]
        let result = vectors.averaged()
        XCTAssertEqual(result, [5.0, 5.0, 5.0])
    }

    func testAveragedSemanticSearchExample() {
        // Example from Chapter 20: averaging word embeddings for document vector
        let wordVectors = [
            [0.2, 0.8, 0.5],  // "running"
            [0.3, 0.7, 0.6],  // "shoes"
            [0.1, 0.6, 0.4]   // "comfortable"
        ]

        guard let documentVector = wordVectors.averaged() else {
            XCTFail("Should successfully average word vectors")
            return
        }

        // Expected: (0.2 + 0.3 + 0.1)/3 = 0.2, (0.8 + 0.7 + 0.6)/3 = 0.7, (0.5 + 0.6 + 0.4)/3 = 0.5
        XCTAssertEqual(documentVector[0], 0.2, accuracy: 1e-10)
        XCTAssertEqual(documentVector[1], 0.7, accuracy: 1e-10)
        XCTAssertEqual(documentVector[2], 0.5, accuracy: 1e-10)
    }

    func testAveragedMathematicalAccuracy() {
        // Test with precise known values
        let vectors = [
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, 10.0, 11.0, 12.0]
        ]

        guard let result = vectors.averaged() else {
            XCTFail("Should successfully average vectors")
            return
        }

        // Expected: (1+5+9)/3 = 5, (2+6+10)/3 = 6, (3+7+11)/3 = 7, (4+8+12)/3 = 8
        XCTAssertEqual(result, [5.0, 6.0, 7.0, 8.0])
    }

    func testAveragedHighDimensional() {
        // Test with higher dimensionality like real word embeddings (50-300 dimensions)
        let dimensions = 50
        let vector1 = [Double](repeating: 1.0, count: dimensions)
        let vector2 = [Double](repeating: 3.0, count: dimensions)

        let vectors = [vector1, vector2]

        guard let result = vectors.averaged() else {
            XCTFail("Should successfully average high-dimensional vectors")
            return
        }

        // Expected: all elements should be 2.0
        XCTAssertEqual(result.count, dimensions)
        for value in result {
            XCTAssertEqual(value, 2.0, accuracy: 1e-10)
        }
    }

    func testAveragedPreservesSemanticRegion() {
        // Test that averaging vectors keeps result in expected region
        // Similar vectors should produce similar averages
        let athleticVectors = [
            [0.8, 0.6, 0.4],  // "lightweight"
            [0.7, 0.5, 0.3],  // "running"
            [0.9, 0.7, 0.5]   // "athletic"
        ]

        guard let athleticAvg = athleticVectors.averaged() else {
            XCTFail("Should successfully average athletic vectors")
            return
        }

        // Expected: [0.8, 0.6, 0.4] (within floating point precision)
        // The average should remain in the "high region" (all components >= 0.4)
        XCTAssertGreaterThanOrEqual(athleticAvg[0], 0.4)
        XCTAssertGreaterThanOrEqual(athleticAvg[1], 0.4)
        XCTAssertGreaterThanOrEqual(athleticAvg[2], 0.4 - 1e-10)  // Allow for floating point precision
    }

    // MARK: - Matrix Operation Tests

    func testColumnExtraction() {
        let matrix = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ]

        let column0 = matrix.column(at: 0)
        let column1 = matrix.column(at: 1)
        let column2 = matrix.column(at: 2)

        XCTAssertEqual(column0, [1, 4, 7])
        XCTAssertEqual(column1, [2, 5, 8])
        XCTAssertEqual(column2, [3, 6, 9])
    }

    func testColumnExtractionWithDoubles() {
        let matrix = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
            [7.0, 8.0, 9.0]
        ]

        let column1 = matrix.column(at: 1)
        XCTAssertEqual(column1, [2.0, 5.0, 8.0])
    }

    func testColumnExtractionRectangularMatrix() {
        // Test with non-square matrix
        let matrix = [
            [1, 2, 3, 4],
            [5, 6, 7, 8]
        ]

        let column2 = matrix.column(at: 2)
        XCTAssertEqual(column2, [3, 7])
    }

    func testColumnExtractionSingleColumn() {
        let matrix = [
            [10],
            [20],
            [30]
        ]

        let column0 = matrix.column(at: 0)
        XCTAssertEqual(column0, [10, 20, 30])
    }

    func testTransposed() {
        let matrix = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ]

        let transposed = matrix.transposed()

        XCTAssertEqual(transposed, [
            [1.0, 4.0],
            [2.0, 5.0],
            [3.0, 6.0]
        ])
    }

    func testTransposedSquareMatrix() {
        let matrix = [
            [1, 2],
            [3, 4]
        ]

        let transposed = matrix.transposed()
        XCTAssertEqual(transposed, [
            [1, 3],
            [2, 4]
        ])
    }

    func testTransposedSameAsTranspose() {
        // Verify that transposed() produces the same result as transpose()
        let matrix = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
            [7.0, 8.0, 9.0]
        ]

        let result1 = matrix.transpose()
        let result2 = matrix.transposed()

        XCTAssertEqual(result1, result2)
    }

    func testMatrixTransformMethod() {
        // Test the new transform() method
        let rotationMatrix = [[0.0, -1.0], [1.0, 0.0]]  // 90° rotation
        let vector = [1.0, 0.0]

        let result = rotationMatrix.transform(vector)
        XCTAssertEqual(result, [0.0, 1.0])
    }

    func testMatrixTransformSameAsTransformedBy() {
        // Verify that matrix.transform(vector) produces same result as vector.transformedBy(matrix)
        let matrix = [[2.0, 0.0], [0.0, 3.0]]  // Scale transformation
        let vector = [4.0, 5.0]

        let result1 = matrix.transform(vector)
        let result2 = vector.transformedBy(matrix)

        XCTAssertEqual(result1, result2)
    }

    func testMatrixTransformScaling() {
        // Test scaling transformation
        let scaleMatrix = [[2.0, 0.0], [0.0, 2.0]]
        let vector = [3.0, 4.0]

        let result = scaleMatrix.transform(vector)
        XCTAssertEqual(result, [6.0, 8.0])
    }

    func testMatrixTransform3D() {
        // Test 3D transformation
        let matrix = [
            [1.0, 0.0, 0.0],
            [0.0, 1.0, 0.0],
            [0.0, 0.0, 2.0]  // Scale z by 2
        ]
        let vector = [1.0, 2.0, 3.0]

        let result = matrix.transform(vector)
        XCTAssertEqual(result, [1.0, 2.0, 6.0])
    }

    func testColumnExtractionGameScoresExample() {
        // Example from Chapter 21: game scores
        let gameScores = [
            [95, 88, 92, 91],  // Player A's scores
            [87, 90, 89, 93],  // Player B's scores
            [92, 94, 88, 96]   // Player C's scores
        ]

        // Extract all scores from game 3 (index 2)
        let game3Scores = gameScores.column(at: 2)
        XCTAssertEqual(game3Scores, [92, 89, 88])
    }

    func testTransposedWithRealWorldData() {
        // Sensor data: rows = sensors, columns = time readings
        let sensorData = [
            [72.1, 73.5, 74.2],
            [71.8, 72.9, 73.7]
        ]

        // Transpose to get: rows = time, columns = sensors
        let timeData = sensorData.transposed()

        // First time reading should have all sensors
        XCTAssertEqual(timeData[0], [72.1, 71.8])
        XCTAssertEqual(timeData[1], [73.5, 72.9])
        XCTAssertEqual(timeData[2], [74.2, 73.7])
    }
}
