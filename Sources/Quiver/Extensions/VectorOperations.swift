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

import Foundation

// MARK: - Standard Numeric Vector Operations

public extension Array where Element: Numeric {

    /// Calculates the dot product of two vectors
    func dot(_ other: [Element]) -> Element {
        let v1 = _Vector(elements: self)
        let v2 = _Vector(elements: other)
        return _Vector.dot(v1, v2)
    }
    
    /// Transform this vector using a matrix (matrix-vector multiplication)
    /// - Parameter matrix: The matrix to transform this vector with
    /// - Returns: The transformed vector
    func transformedBy(_ matrix: [[Element]]) -> [Element] {
        // Check if the matrix dimensions are compatible with this vector
        guard !matrix.isEmpty,
              let firstRow = matrix.first,
              firstRow.count == self.count else {
            preconditionFailure("Invalid matrix dimensions or vector length")
        }
        
        // Ensure all rows have the same length
        for row in matrix {
            guard row.count == firstRow.count else {
                preconditionFailure("All matrix rows must have the same length")
            }
        }
        
        // Convert to internal _Vector and use the internal implementation
        let vectorObj = _Vector(elements: self)
        
        let result = _Vector.matrixVectorTransform(matrix, vectorObj)
        return result.elements
    }
}

extension Array where Element: Collection, Element.Element: Numeric {
    /// Returns the transpose of a matrix
    ///
    /// This method is only available on 2D arrays (arrays of collections) where the inner elements
    /// are numeric types. For example, it works with [[1, 2], [3, 4]] or [[1.0, 2.0], [3.0, 4.0]],
    /// but not with [1, 2, 3, 4] or [["a", "b"], ["c", "d"]].
    ///
    /// The transpose operation converts rows into columns and columns into rows:
    /// - For a matrix with dimensions m×n, the result will have dimensions n×m
    /// - Each element at position (i,j) in the original matrix will be at position (j,i) in the transposed matrix
    ///
    /// - Returns: A new matrix where rows become columns and columns become rows
    func transpose() -> [[Element.Element]] {
        guard !self.isEmpty, !self[0].isEmpty else { return [] }

        // Convert to array of arrays for internal implementation
        let matrixArray = self.map { row -> [Element.Element] in
            return row.map { $0 }
        }

        // Call the internal implementation from _Vector
        return _Vector.transpose(matrixArray)
    }

    /// Returns the transpose of a matrix (convenience method matching Swift naming conventions)
    ///
    /// This is an alias for `transpose()` that follows Swift's convention of using past participle
    /// forms for methods that return transformed copies.
    ///
    /// - Returns: A new matrix where rows become columns and columns become rows
    func transposed() -> [[Element.Element]] {
        return self.transpose()
    }

    /// Extracts a column from a matrix at the specified index
    ///
    /// This method provides an intuitive way to extract vertical slices from matrices,
    /// which is otherwise awkward in Swift. For example:
    ///
    /// ```swift
    /// let matrix = [[1, 2, 3],
    ///               [4, 5, 6],
    ///               [7, 8, 9]]
    /// let secondColumn = matrix.column(at: 1)  // [2, 5, 8]
    /// ```
    ///
    /// - Parameter index: The column index to extract
    /// - Returns: An array containing all elements from the specified column
    func column(at index: Element.Index) -> [Element.Element] {
        return self.map { $0[index] }
    }

    /// Transforms a vector by this matrix (matrix-vector multiplication)
    ///
    /// This method provides a more intuitive API for matrix-vector multiplication where
    /// the matrix acts on the vector, which matches mathematical notation: **Mv = w**
    ///
    /// For example, to rotate a 2D vector 90 degrees counterclockwise:
    /// ```swift
    /// let rotationMatrix = [[0.0, -1.0],
    ///                       [1.0,  0.0]]
    /// let vector = [1.0, 0.0]
    /// let rotated = rotationMatrix.transform(vector)  // [0.0, 1.0]
    /// ```
    ///
    /// - Parameter vector: The vector to transform
    /// - Returns: The transformed vector
    func transform(_ vector: [Element.Element]) -> [Element.Element] {
        // Convert self (which is [Element] where Element: Collection) to [[Element.Element]]
        let matrixArray = self.map { row -> [Element.Element] in
            return row.map { $0 }
        }
        return vector.transformedBy(matrixArray)
    }

    /// Matrix-matrix multiplication
    ///
    /// Multiplies this matrix by another matrix following standard matrix multiplication rules.
    /// This method provides clear, descriptive naming for matrix multiplication operations.
    ///
    /// For matrices A (n×k) and B (k×m), produces result C (n×m) where:
    /// `C[i][j] = sum of (A[i][k] * B[k][j])` for all k
    ///
    /// Example:
    /// ```swift
    /// let scale2x = [[2.0, 0.0], [0.0, 2.0]]
    /// let rotate45 = [[0.707, -0.707], [0.707, 0.707]]
    /// let combined = scale2x.multiplyMatrix(rotate45)
    /// ```
    ///
    /// - Parameter other: The matrix to multiply with (must have compatible dimensions)
    /// - Returns: The resulting matrix
    func multiplyMatrix(_ other: [[Element.Element]]) -> [[Element.Element]] {
        // Convert self to [[Element.Element]]
        let lhsMatrix = self.map { row -> [Element.Element] in
            return row.map { $0 }
        }

        return _Vector<Element.Element>.matrixMatrixMultiply(lhsMatrix, other)
    }
}


// MARK: - FloatingPoint Vector Operations

public extension Array where Element: FloatingPoint {
    /// Calculates the magnitude (length) of the vector
    var magnitude: Element {
        let v = _Vector(elements: self)
        return v.magnitude()
    }
    
    /// Returns a normalized version of the vector (unit vector)
    var normalized: [Element] {
        let v = _Vector(elements: self)
        return v.normalized().elements
    }
    
    /// Calculate the distance between two points or vectors
    func distance(to other: [Element]) -> Element {
        return (self - other).magnitude
    }
        
    /// Returns the cosine of the angle between two vectors
    func cosineOfAngle(with other: [Element]) -> Element {
        let dotProduct = self.dot(other)
        let magnitudeProduct = self.magnitude * other.magnitude
        
        precondition(magnitudeProduct > 0, "Cannot calculate angle with zero vector")
        return dotProduct / magnitudeProduct
    }

    /// Calculates the scalar projection of this vector onto another vector
    ///
    /// The scalar projection represents the length of the shadow cast by this vector
    /// onto the direction of the other vector.
    ///
    /// - Parameter vector: The vector to project onto
    /// - Returns: The scalar projection value
    func scalarProjection(onto vector: [Element]) -> Element {
        let v1 = _Vector(elements: self)
        let v2 = _Vector(elements: vector)
        return v1.scalarProjection(onto: v2)
    }
    
    /// Calculates the vector projection of this vector onto another vector
    ///
    /// The vector projection is the vector component of this vector
    /// in the direction of the other vector.
    ///
    /// - Parameter vector: The vector to project onto
    /// - Returns: The projected vector
    func vectorProjection(onto vector: [Element]) -> [Element] {
        let v1 = _Vector(elements: self)
        let v2 = _Vector(elements: vector)
        return v1.vectorProjection(onto: v2).elements
    }
    
    /// Returns the orthogonal component of this vector with respect to another vector
    ///
    /// This returns the component of this vector that is perpendicular to the other vector.
    ///
    /// - Parameter vector: The reference vector
    /// - Returns: The orthogonal component
    func orthogonalComponent(to vector: [Element]) -> [Element] {
        let projection = self.vectorProjection(onto: vector)
        return self - projection
    }
}

// MARK: - Double Vector Operations

public extension Array where Element == [Double] {

    /// Returns whether all vectors in the collection have the same dimension count.
    /// Used to validate that a collection of vectors can be used together in mathematical operations.
    func areValidVectorDimensions() -> Bool {
        guard let firstCount = self.first?.count else {
            return false
        }
        
        return self.allSatisfy { $0.count == firstCount }
    }
    
    /// Calculates the element-wise average of a collection of vectors.
    /// Returns nil if the input is empty or vectors have inconsistent dimensions.
    /// Calculates the element-wise average of the vectors in this array
    func averaged() -> [Double]? {
        // Return nil if no vectors to average
        guard !self.isEmpty else { return nil }
        
        // Ensure all vectors have consistent dimensions
        guard self.areValidVectorDimensions() else { return nil }
        
        // Initialize sum vector with matching dimensions
        let dimensions = self[0].count
        var sum = [Double].zeros(dimensions)
        
        // Sum all vectors element-wise
        for vector in self {
            sum = sum + vector
        }
        
        // Divide by count to get average
        return sum.broadcast(dividingBy: Double(self.count))
    }
    
    /// Calculate cosine similarities between each vector in the array and a target vector.
    /// Returns an array of similarity scores where each score represents how similar
    /// the corresponding vector is to the target (1.0 = identical, 0.0 = orthogonal).
    func cosineSimilarities(to target: [Double]) -> [Double] {
        return self.map { $0.cosineOfAngle(with: target) }
    }
}

// MARK: - Array Ranking Operations

public extension Array where Element == Double {

    /// Returns the indices and values of the top K highest elements.
    ///
    /// This method sorts the array in descending order and returns the indices and values
    /// of the top K elements. Commonly used in similarity search, recommendation systems,
    /// and ranking operations.
    ///
    /// Example:
    /// ```swift
    /// let scores = [0.3, 0.9, 0.1, 0.7, 0.5]
    /// let top3 = scores.topIndices(k: 3)
    /// // Returns: [(index: 1, score: 0.9), (index: 3, score: 0.7), (index: 4, score: 0.5)]
    /// ```
    ///
    /// - Parameter k: Number of top elements to return
    /// - Returns: Array of tuples containing index and score, sorted by score (highest first)
    func topIndices(k: Int) -> [(index: Int, score: Double)] {
        return self.enumerated()
            .map { (index: $0.offset, score: $0.element) }
            .sorted { $0.score > $1.score }
            .prefix(k)
            .map { $0 }
    }

}

// MARK: - Float Vector Operations

public extension Array where Element == [Float] {
    /// Calculate cosine similarities between each vector in the array and a target vector.
    /// Returns an array of similarity scores where each score represents how similar
    /// the corresponding vector is to the target (1.0 = identical, 0.0 = orthogonal).
    func cosineSimilarities(to target: [Float]) -> [Float] {
        return self.map { $0.cosineOfAngle(with: target) }
    }
}

