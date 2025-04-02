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
    
    /// Returns the shape of the array (NumPy-like)
    /// For vectors: (length, 0)
    /// For matrices: (rows, columns)
    var shape: (rows: Int, columns: Int) {
        // Check if this is a matrix (2D array)
        if let matrix = self as? [[Any]], !matrix.isEmpty {
            let rowCount = matrix.count
            let columnCount = matrix[0].count
            return (rowCount, columnCount)
        }
        
        // Otherwise, treat as a vector
        return (self.count, 0)
    }
    
   /// Returns true if this array represents a valid matrix (2D array with consistent row lengths)
   var isMatrix: Bool {
       guard let firstRow = self.first as? [Element] else { return false }
       return self.allSatisfy { row in
           guard let row = row as? [Element] else { return false }
           return row.count == firstRow.count
       }
   }
   
   /// Returns the dimensions of the matrix as (rows, columns) if this is a valid matrix
   var matrixDimensions: (rows: Int, columns: Int)? {
       guard isMatrix, let firstRow = self.first as? [Element] else { return nil }
       return (self.count, firstRow.count)
   }
    
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
