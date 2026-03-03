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

    // MARK: - Basic Vector Operations

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

    // MARK: - Cosine and Angle Tests

    func testCosineOfAngle() {
        // 45 degrees
        let v1 = [1.0, 0.0]
        let v2 = [1.0, 1.0]
        let cosine = v1.cosineOfAngle(with: v2)
        XCTAssertEqual(cosine, 1.0/sqrt(2.0), accuracy: 1e-10)

        // Perpendicular vectors
        let v3 = [0.0, 1.0]
        XCTAssertEqual(v1.cosineOfAngle(with: v3), 0.0, accuracy: 1e-10)

        // Parallel vectors
        let v4 = [3.0, 4.0]
        let v5 = [6.0, 8.0]
        XCTAssertEqual(v4.cosineOfAngle(with: v5), 1.0, accuracy: 1e-10)
    }

    func testCosineSimilarities() {
        let vectors = [
            [1.0, 0.0],      // Along x-axis
            [0.0, 1.0]       // Along y-axis (perpendicular)
        ]
        let target = [1.0, 0.0]

        let similarities = vectors.cosineSimilarities(to: target)

        XCTAssertEqual(similarities[0], 1.0, accuracy: 1e-10)
        XCTAssertEqual(similarities[1], 0.0, accuracy: 1e-10)

        // Empty array
        let empty: [[Double]] = []
        XCTAssertTrue(empty.cosineSimilarities(to: target).isEmpty)
    }

    // MARK: - Projection Tests

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

    // MARK: - Distance Tests

    func testDistance() {
        // Classic 3-4-5 triangle
        let v1 = [0.0, 0.0]
        let v2 = [3.0, 4.0]
        XCTAssertEqual(v1.distance(to: v2), 5.0)

        // Symmetric
        let pointA = [1.0, 2.0, 3.0]
        let pointB = [4.0, 6.0, 8.0]
        XCTAssertEqual(pointA.distance(to: pointB), pointB.distance(to: pointA), accuracy: 1e-10)

        // Distance to self is zero
        XCTAssertEqual(pointA.distance(to: pointA), 0.0)
    }

    // MARK: - Matrix Transformation Tests

    func testMatrixTransformation() {
        let v = [1.0, 2.0]
        let matrix = [[0.0, -1.0], [1.0, 0.0]]  // 90° rotation
        let result = v.transformedBy(matrix)
        XCTAssertEqual(result, [-2.0, 1.0])
    }

    func testMatrixTransform() {
        // 90° rotation
        let rotationMatrix = [[0.0, -1.0], [1.0, 0.0]]
        let vector = [1.0, 0.0]
        let result = rotationMatrix.transform(vector)
        XCTAssertEqual(result, [0.0, 1.0])

        // Verify transform() matches transformedBy()
        let matrix = [[2.0, 0.0], [0.0, 3.0]]
        let v = [4.0, 5.0]
        XCTAssertEqual(matrix.transform(v), v.transformedBy(matrix))

        // 3D transformation
        let matrix3D = [
            [1.0, 0.0, 0.0],
            [0.0, 1.0, 0.0],
            [0.0, 0.0, 2.0]
        ]
        XCTAssertEqual(matrix3D.transform([1.0, 2.0, 3.0]), [1.0, 2.0, 6.0])
    }

    // MARK: - Averaged Tests

    func testAveraged() {
        let vectors = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
            [7.0, 8.0, 9.0]
        ]
        let result = vectors.averaged()
        XCTAssertEqual(result, [4.0, 5.0, 6.0])
    }

    func testAveragedEdgeCases() {
        // Empty array
        XCTAssertNil(([[Double]]()).averaged())

        // Invalid dimensions
        let invalid = [[1.0, 2.0, 3.0], [4.0, 5.0]]
        XCTAssertNil(invalid.averaged())

        // Single vector
        XCTAssertEqual([[3.0, 4.0, 5.0]].averaged(), [3.0, 4.0, 5.0])
    }

    func testAveragedSemanticExample() {
        // Averaging word embeddings for document vector
        let wordVectors = [
            [0.2, 0.8, 0.5],
            [0.3, 0.7, 0.6],
            [0.1, 0.6, 0.4]
        ]

        guard let documentVector = wordVectors.averaged() else {
            XCTFail("Should successfully average word vectors")
            return
        }

        XCTAssertEqual(documentVector[0], 0.2, accuracy: 1e-10)
        XCTAssertEqual(documentVector[1], 0.7, accuracy: 1e-10)
        XCTAssertEqual(documentVector[2], 0.5, accuracy: 1e-10)
    }

    // MARK: - Column Extraction Tests

    func testColumnExtraction() {
        let matrix = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ]

        XCTAssertEqual(matrix.column(at: 0), [1, 4, 7])
        XCTAssertEqual(matrix.column(at: 1), [2, 5, 8])
        XCTAssertEqual(matrix.column(at: 2), [3, 6, 9])
    }

    func testColumnExtractionRectangularMatrix() {
        let matrix = [
            [1, 2, 3, 4],
            [5, 6, 7, 8]
        ]
        XCTAssertEqual(matrix.column(at: 2), [3, 7])
    }

    // MARK: - Transpose Tests

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

        // Verify transposed() and transpose() produce same result
        let square = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
        XCTAssertEqual(square.transpose(), square.transposed())
    }

    // MARK: - Matrix Multiplication Tests

    func testMatmul2x2() {
        let a = [[1.0, 2.0], [3.0, 4.0]]
        let b = [[5.0, 6.0], [7.0, 8.0]]
        let result = a.multiplyMatrix(b)
        XCTAssertEqual(result, [[19.0, 22.0], [43.0, 50.0]])
    }

    func testMatmulIdentityMatrix() {
        let identity = [[1.0, 0.0], [0.0, 1.0]]
        let matrix = [[3.0, 4.0], [5.0, 6.0]]
        XCTAssertEqual(identity.multiplyMatrix(matrix), matrix)
    }

    func testMatmulNonSquareMatrices() {
        // (2×3) × (3×2) → (2×2)
        let a = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let b = [[7.0, 8.0], [9.0, 10.0], [11.0, 12.0]]
        let result = a.multiplyMatrix(b)
        XCTAssertEqual(result, [[58.0, 64.0], [139.0, 154.0]])
    }

    func testMatmulRotationComposition() {
        // Two 90° rotations = 180° rotation
        let rotate90 = [[0.0, -1.0], [1.0, 0.0]]
        let result = rotate90.multiplyMatrix(rotate90)
        XCTAssertEqual(result[0][0], -1.0, accuracy: 1e-10)
        XCTAssertEqual(result[0][1], 0.0, accuracy: 1e-10)
        XCTAssertEqual(result[1][0], 0.0, accuracy: 1e-10)
        XCTAssertEqual(result[1][1], -1.0, accuracy: 1e-10)
    }

    func testMatmulNonCommutative() {
        let a = [[1.0, 2.0], [3.0, 4.0]]
        let b = [[5.0, 6.0], [7.0, 8.0]]
        XCTAssertNotEqual(a.multiplyMatrix(b), b.multiplyMatrix(a))
    }

    func testMatmulTransformComposition() {
        // Compose rotation → scaling, verify matches sequential application
        let rotate = [[0.707, -0.707], [0.707, 0.707]]
        let scale = [[2.0, 0.0], [0.0, 3.0]]
        let composed = scale.multiplyMatrix(rotate)

        let vector = [1.0, 0.0]
        let result = composed.transform(vector)

        let step1 = rotate.transform(vector)
        let step2 = scale.transform(step1)

        XCTAssertEqual(result[0], step2[0], accuracy: 1e-10)
        XCTAssertEqual(result[1], step2[1], accuracy: 1e-10)
    }

    func testMatmul3x3() {
        let a = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
            [7.0, 8.0, 9.0]
        ]
        let b = [
            [9.0, 8.0, 7.0],
            [6.0, 5.0, 4.0],
            [3.0, 2.0, 1.0]
        ]
        let result = a.multiplyMatrix(b)
        XCTAssertEqual(result, [
            [30.0, 24.0, 18.0],
            [84.0, 69.0, 54.0],
            [138.0, 114.0, 90.0]
        ])
    }

    func testMatmulWithIntegers() {
        let a = [[1, 2], [3, 4]]
        let b = [[5, 6], [7, 8]]
        XCTAssertEqual(a.multiplyMatrix(b), [[19, 22], [43, 50]])
    }

    // MARK: - TopIndices Tests

    func testTopIndicesBasic() {
        let scores = [0.3, 0.9, 0.1, 0.7, 0.5]
        let top3 = scores.topIndices(k: 3)

        XCTAssertEqual(top3.count, 3)
        XCTAssertEqual(top3[0].index, 1)
        XCTAssertEqual(top3[0].score, 0.9)
        XCTAssertEqual(top3[1].index, 3)
        XCTAssertEqual(top3[1].score, 0.7)
        XCTAssertEqual(top3[2].index, 4)
        XCTAssertEqual(top3[2].score, 0.5)
    }

    func testTopIndicesEdgeCases() {
        // More than available
        let scores = [0.3, 0.9]
        let top5 = scores.topIndices(k: 5)
        XCTAssertEqual(top5.count, 2)

        // Empty array
        let empty: [Double] = []
        XCTAssertEqual(empty.topIndices(k: 3).count, 0)

        // Duplicates
        let dups = [0.5, 0.9, 0.5, 0.9, 0.3]
        let top3 = dups.topIndices(k: 3)
        XCTAssertEqual(top3[0].score, 0.9)
        XCTAssertEqual(top3[1].score, 0.9)
    }

    func testTopIndicesWithLabels() {
        let scores = [0.3, 0.9, 0.1, 0.7]
        let words = ["the", "cat", "dog", "sat"]

        let predictions = scores.topIndices(k: 2, labels: words)

        XCTAssertEqual(predictions.count, 2)
        XCTAssertEqual(predictions[0].label, "cat")
        XCTAssertEqual(predictions[0].score, 0.9, accuracy: 0.001)
        XCTAssertEqual(predictions[1].label, "sat")
        XCTAssertEqual(predictions[1].score, 0.7, accuracy: 0.001)
    }

    // MARK: - FindDuplicates Tests

    func testFindDuplicatesBasic() {
        let documents = [
            [0.8, 0.6, 0.9],
            [0.8, 0.6, 0.9],  // Exact duplicate of first
            [0.1, 0.2, 0.1]
        ]

        let duplicates = documents.findDuplicates(threshold: 0.95)

        XCTAssertEqual(duplicates.count, 1)
        XCTAssertEqual(duplicates[0].index1, 0)
        XCTAssertEqual(duplicates[0].index2, 1)
        XCTAssertEqual(duplicates[0].similarity, 1.0, accuracy: 1e-10)
    }

    func testFindDuplicatesNoDuplicates() {
        let documents = [
            [1.0, 0.0, 0.0],
            [0.0, 1.0, 0.0],
            [0.0, 0.0, 1.0]
        ]
        XCTAssertEqual(documents.findDuplicates(threshold: 0.95).count, 0)
    }

    func testFindDuplicatesMultiplePairs() {
        let documents = [
            [1.0, 0.0, 0.0],
            [1.0, 0.0, 0.0],  // Duplicate of 0
            [0.0, 1.0, 0.0],
            [0.0, 1.0, 0.0],  // Duplicate of 2
            [0.0, 0.0, 1.0]
        ]

        let duplicates = documents.findDuplicates(threshold: 0.99)
        XCTAssertEqual(duplicates.count, 2)

        let allIndices = [(duplicates[0].index1, duplicates[0].index2), (duplicates[1].index1, duplicates[1].index2)]
        XCTAssertTrue(allIndices.contains { $0 == (0, 1) })
        XCTAssertTrue(allIndices.contains { $0 == (2, 3) })
    }

    func testFindDuplicatesCustomThreshold() {
        let documents = [
            [0.8, 0.6],
            [0.7, 0.7],
        ]

        XCTAssertEqual(documents.findDuplicates(threshold: 0.99).count, 0)
        XCTAssertEqual(documents.findDuplicates(threshold: 0.90).count, 1)
    }

    // MARK: - ClusterCohesion Tests

    func testClusterCohesionPerfectCluster() {
        let cluster = [
            [1.0, 0.0, 0.0],
            [1.0, 0.0, 0.0],
            [1.0, 0.0, 0.0]
        ]
        XCTAssertEqual(cluster.clusterCohesion(), 1.0, accuracy: 1e-10)
    }

    func testClusterCohesionLowCohesion() {
        // Orthogonal vectors
        let cluster = [
            [1.0, 0.0, 0.0],
            [0.0, 1.0, 0.0],
            [0.0, 0.0, 1.0]
        ]
        XCTAssertEqual(cluster.clusterCohesion(), 0.0, accuracy: 1e-10)
    }

    func testClusterCohesionEdgeCases() {
        // Single vector
        XCTAssertEqual([[0.5, 0.5, 0.5]].clusterCohesion(), 0.0)

        // Empty array
        XCTAssertEqual(([[Double]]()).clusterCohesion(), 0.0)

        // Two vectors — should equal cosine similarity between them
        let cluster = [[0.8, 0.6], [0.6, 0.8]]
        let expected = cluster[0].cosineOfAngle(with: cluster[1])
        XCTAssertEqual(cluster.clusterCohesion(), expected, accuracy: 1e-10)
    }

    // MARK: - Sum Tests

    func testSum() {
        XCTAssertEqual([1.0, 2.0, 3.0, 4.0].sum(), 10.0)
        XCTAssertEqual([5, 10, 15, 20].sum(), 50)
        XCTAssertEqual([-5.0, 3.0, -2.0, 8.0].sum(), 4.0)
        XCTAssertEqual([Double]().sum(), 0.0)
    }

    // MARK: - SortedIndices Tests

    func testSortedIndicesBasic() {
        let values = [40.0, 10.0, 30.0, 20.0]
        XCTAssertEqual(values.sortedIndices(), [1, 3, 2, 0])
    }

    func testSortedIndicesVerifyMapping() {
        let values = [5.0, 2.0, 8.0, 1.0]
        let sorted = values.sortedIndices().map { values[$0] }
        XCTAssertEqual(sorted, [1.0, 2.0, 5.0, 8.0])
    }

    func testSortedIndicesEdgeCases() {
        // Duplicates
        let dups = [3.0, 1.0, 3.0, 2.0]
        let sorted = dups.sortedIndices().map { dups[$0] }
        XCTAssertEqual(sorted, [1.0, 2.0, 3.0, 3.0])

        // Empty array
        XCTAssertEqual([Double]().sortedIndices(), [])

        // Already sorted
        XCTAssertEqual([1.0, 2.0, 3.0, 4.0].sortedIndices(), [0, 1, 2, 3])
    }

    // MARK: - Matrix Determinant Tests

    func testDeterminant() {
        // 1x1
        XCTAssertEqual([[5.0]].determinant, 5.0)

        // 2x2
        let m2 = [[3.0, 8.0], [4.0, 6.0]]
        XCTAssertEqual(m2.determinant, -14.0)

        // 2x2 identity
        XCTAssertEqual([[1.0, 0.0], [0.0, 1.0]].determinant, 1.0)

        // 3x3
        let m3 = [
            [1.0, 2.0, 3.0],
            [0.0, 1.0, 4.0],
            [5.0, 6.0, 0.0]
        ]
        XCTAssertEqual(m3.determinant, 1.0, accuracy: 1e-10)

        // Singular
        let singular = [[1.0, 2.0], [2.0, 4.0]]
        XCTAssertEqual(singular.determinant, 0.0, accuracy: 1e-10)
    }

    // MARK: - Matrix Inverse Tests

    func testInverted2x2() throws {
        let matrix = [[4.0, 7.0], [2.0, 6.0]]
        let inverse = try matrix.inverted()

        // Verify A * A^-1 = I
        let identity = matrix.multiplyMatrix(inverse)
        XCTAssertEqual(identity[0][0], 1.0, accuracy: 1e-10)
        XCTAssertEqual(identity[0][1], 0.0, accuracy: 1e-10)
        XCTAssertEqual(identity[1][0], 0.0, accuracy: 1e-10)
        XCTAssertEqual(identity[1][1], 1.0, accuracy: 1e-10)
    }

    func testInverted3x3() throws {
        let matrix = [
            [1.0, 2.0, 3.0],
            [0.0, 1.0, 4.0],
            [5.0, 6.0, 0.0]
        ]
        let inverse = try matrix.inverted()
        let identity = matrix.multiplyMatrix(inverse)

        for i in 0..<3 {
            for j in 0..<3 {
                XCTAssertEqual(identity[i][j], i == j ? 1.0 : 0.0, accuracy: 1e-10)
            }
        }
    }

    func testInvertedErrorCases() {
        // Singular matrix
        let singular = [[1.0, 2.0], [2.0, 4.0]]
        XCTAssertThrowsError(try singular.inverted()) { error in
            XCTAssertEqual(error as? MatrixError, .singular)
        }

        // Non-square matrix
        let nonSquare = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        XCTAssertThrowsError(try nonSquare.inverted()) { error in
            XCTAssertEqual(error as? MatrixError, .notSquare)
        }
    }

    // MARK: - LogDeterminant Tests

    func testLogDeterminant() {
        // 2x2
        let m2 = [[4.0, 3.0], [6.0, 3.0]]
        let ld2 = m2.logDeterminant
        XCTAssertEqual(ld2.sign, -1.0)
        XCTAssertEqual(ld2.logAbsValue, log(6.0), accuracy: 1e-10)
        XCTAssertEqual(ld2.value, -6.0, accuracy: 1e-10)

        // Identity
        let identity = [[1.0, 0.0], [0.0, 1.0]]
        let ldI = identity.logDeterminant
        XCTAssertEqual(ldI.sign, 1.0)
        XCTAssertEqual(ldI.logAbsValue, 0.0, accuracy: 1e-10)

        // Singular
        let singular = [[1.0, 2.0], [2.0, 4.0]]
        let ldS = singular.logDeterminant
        XCTAssertEqual(ldS.sign, 0.0)
        XCTAssertTrue(ldS.logAbsValue.isInfinite && ldS.logAbsValue < 0)
    }

    func testLogDeterminantConsistentWithDeterminant() {
        let matrices: [[[Double]]] = [
            [[3.0, 8.0], [4.0, 6.0]],
            [[2.0, 0.0], [0.0, 2.0]],
            [[1.0, 2.0, 3.0], [0.0, 1.0, 4.0], [5.0, 6.0, 0.0]],
            [[4.0, 7.0], [2.0, 6.0]]
        ]

        for matrix in matrices {
            let det = matrix.determinant
            let ld = matrix.logDeterminant
            XCTAssertEqual(ld.value, det, accuracy: 1e-10)
        }
    }

    // MARK: - Condition Number Tests

    func testConditionNumberIdentity() {
        let identity = [[1.0, 0.0], [0.0, 1.0]]
        XCTAssertEqual(identity.conditionNumber, 1.0, accuracy: 1e-10)
    }

    func testConditionNumberSingular() {
        let singular = [[1.0, 2.0], [2.0, 4.0]]
        XCTAssertTrue(singular.conditionNumber.isInfinite)
    }

    func testConditionNumberDiagonal() {
        let matrix = [[2.0, 0.0], [0.0, 8.0]]
        XCTAssertEqual(matrix.conditionNumber, 4.0, accuracy: 1e-10)
    }

    func testConditionNumberScaling() {
        // Scaling by a constant should not change condition number
        let matrix = [[4.0, 1.0], [1.0, 3.0]]
        let scaled = [[8.0, 2.0], [2.0, 6.0]]
        XCTAssertEqual(matrix.conditionNumber, scaled.conditionNumber, accuracy: 1e-10)
    }
}
