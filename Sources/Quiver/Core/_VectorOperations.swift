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

// MARK: - Basic Element-wise Operations

extension _Vector where Element: Numeric {
    
    /// Element-wise addition of two vectors
    static func add(_ lhs: _Vector<Element>, _ rhs: _Vector<Element>) -> _Vector<Element> {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = [Element]()
        for i in 0..<lhs.elements.count {
            result.append(lhs.elements[i] + rhs.elements[i])
        }
        return _Vector(elements: result)
    }
    
    /// Element-wise subtraction of two vectors
    static func subtract(_ lhs: _Vector<Element>, _ rhs: _Vector<Element>) -> _Vector<Element> {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = [Element]()
        for i in 0..<lhs.elements.count {
            result.append(lhs.elements[i] - rhs.elements[i])
        }
        return _Vector(elements: result)
    }
    
    /// Element-wise multiplication of two vectors
    static func multiply(_ lhs: _Vector<Element>, _ rhs: _Vector<Element>) -> _Vector<Element> {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = [Element]()
        for i in 0..<lhs.elements.count {
            result.append(lhs.elements[i] * rhs.elements[i])
        }
        return _Vector(elements: result)
    }
    
    
    /// Calculates the dot product of two vectors
    static func dot(_ lhs: _Vector<Element>, _ rhs: _Vector<Element>) -> Element {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = Element.zero
        for i in 0..<lhs.elements.count {
            result += lhs.elements[i] * rhs.elements[i]
        }
        return result
    }
    
    /// Matrix-vector multiplication
    static func matrixVectorTransform(_ matrix: [[Element]], _ vector: _Vector<Element>) -> _Vector<Element> {
        precondition(matrix.first?.count == vector.elements.count, "Matrix columns must match vector length")
        
        var resultElements = [Element]()
        for row in matrix {
            let rowVector = _Vector(elements: row)
            resultElements.append(_Vector.dot(rowVector, vector))
        }
        
        return _Vector(elements: resultElements)
    }
    
    /// Returns the transpose of a matrix
    static func transpose(_ matrix: [[Element]]) -> [[Element]] {
        guard !matrix.isEmpty, !matrix[0].isEmpty else { return [] }
        
        let rows = matrix.count
        let cols = matrix[0].count
        
        // Create an empty result matrix with swapped dimensions
        var result = [[Element]]()
        for _ in 0..<cols {
            result.append([Element](repeating: .zero, count: rows))
        }
        
        // Fill the transposed matrix
        for i in 0..<rows {
            for j in 0..<cols {
                result[j][i] = matrix[i][j]
            }
        }
        
        return result
    }
    
    
}

// MARK: - Floating Point Operations

extension _Vector where Element: FloatingPoint {
    /// Element-wise division of two vectors
    static func divide(_ lhs: _Vector<Element>, _ rhs: _Vector<Element>) -> _Vector<Element> {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = [Element]()
        for i in 0..<lhs.elements.count {
            precondition(rhs.elements[i] != 0, "Division by zero")
            result.append(lhs.elements[i] / rhs.elements[i])
        }
        return _Vector(elements: result)
    }
    
    /// Calculates the magnitude (length) of a vector
    func magnitude() -> Element {
        var sumOfSquares = Element.zero
        for element in elements {
            sumOfSquares += element * element
        }
        return sumOfSquares.squareRoot()
    }
    
    /// Returns a normalized version of the vector (unit vector)
    func normalized() -> _Vector<Element> {
        let mag = magnitude()
        precondition(mag > 0, "Cannot normalize a zero vector")
        
        var normalizedElements = [Element]()
        for element in elements {
            normalizedElements.append(element / mag)
        }
        return _Vector(elements: normalizedElements)
    }

    /// Calculates the scalar projection of this vector onto another vector
    func scalarProjection(onto other: _Vector<Element>) -> Element {
        let dotProduct = _Vector.dot(self, other)
        let magnitude = other.magnitude()
        
        precondition(magnitude > 0, "Cannot project onto a zero vector")
        return dotProduct / magnitude
    }
    
    /// Calculates the vector projection of this vector onto another vector
    func vectorProjection(onto other: _Vector<Element>) -> _Vector<Element> {
        let dotProduct = _Vector.dot(self, other)
        let otherDotProduct = _Vector.dot(other, other)
        
        precondition(otherDotProduct > 0, "Cannot project onto a zero vector")
        
        // Calculate the scalar multiple
        let scalar = dotProduct / otherDotProduct
        
        // Create a new vector by scaling each component
        var projectedElements = [Element]()
        for element in other.elements {
            projectedElements.append(element * scalar)
        }
        
        return _Vector(elements: projectedElements)
    }
}
