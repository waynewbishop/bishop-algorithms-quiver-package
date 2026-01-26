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

// MARK: - Basic Arithmetic Operations

public extension Array where Element: Numeric {
    /// Element-wise addition of two vectors
    static func + (lhs: [Element], rhs: [Element]) -> [Element] {
        let v1 = _Vector(elements: lhs)
        let v2 = _Vector(elements: rhs)
        return _Vector.add(v1, v2).elements
    }
    
    /// Element-wise subtraction of two vectors
    static func - (lhs: [Element], rhs: [Element]) -> [Element] {
        let v1 = _Vector(elements: lhs)
        let v2 = _Vector(elements: rhs)
        return _Vector.subtract(v1, v2).elements
    }
    
    /// Element-wise multiplication of two vectors
    static func * (lhs: [Element], rhs: [Element]) -> [Element] {
        let v1 = _Vector(elements: lhs)
        let v2 = _Vector(elements: rhs)
        return _Vector.multiply(v1, v2).elements
    }
}

// Division is only available for floating point types
public extension Array where Element: FloatingPoint {
    /// Element-wise division of two vectors
    static func / (lhs: [Element], rhs: [Element]) -> [Element] {
        let v1 = _Vector(elements: lhs)
        let v2 = _Vector(elements: rhs)
        return _Vector<Element>.divide(v1, v2).elements
    }
}

// MARK: - Matrix Arithmetic Operations (Double)

public extension Array where Element == [Double] {
    /// Element-wise addition of two matrices
    /// - Parameters:
    ///   - lhs: The first matrix
    ///   - rhs: The second matrix
    /// - Returns: A new matrix where each element is the sum of corresponding elements
    static func + (lhs: [[Double]], rhs: [[Double]]) -> [[Double]] {
        precondition(lhs.count == rhs.count, "Matrices must have same number of rows")
        precondition(!lhs.isEmpty, "Cannot add empty matrices")

        return zip(lhs, rhs).map { row1, row2 in
            row1 + row2  // Uses vector addition
        }
    }

    /// Element-wise subtraction of two matrices
    /// - Parameters:
    ///   - lhs: The first matrix
    ///   - rhs: The second matrix
    /// - Returns: A new matrix where each element is the difference of corresponding elements
    static func - (lhs: [[Double]], rhs: [[Double]]) -> [[Double]] {
        precondition(lhs.count == rhs.count, "Matrices must have same number of rows")
        precondition(!lhs.isEmpty, "Cannot subtract empty matrices")

        return zip(lhs, rhs).map { row1, row2 in
            row1 - row2  // Uses vector subtraction
        }
    }

    /// Element-wise multiplication of two matrices (Hadamard product)
    /// - Parameters:
    ///   - lhs: The first matrix
    ///   - rhs: The second matrix
    /// - Returns: A new matrix where each element is the product of corresponding elements
    static func * (lhs: [[Double]], rhs: [[Double]]) -> [[Double]] {
        precondition(lhs.count == rhs.count, "Matrices must have same number of rows")
        precondition(!lhs.isEmpty, "Cannot multiply empty matrices")

        return zip(lhs, rhs).map { row1, row2 in
            row1 * row2  // Uses vector multiplication
        }
    }

    /// Element-wise division of two matrices
    /// - Parameters:
    ///   - lhs: The first matrix
    ///   - rhs: The second matrix
    /// - Returns: A new matrix where each element is the quotient of corresponding elements
    static func / (lhs: [[Double]], rhs: [[Double]]) -> [[Double]] {
        precondition(lhs.count == rhs.count, "Matrices must have same number of rows")
        precondition(!lhs.isEmpty, "Cannot divide empty matrices")

        return zip(lhs, rhs).map { row1, row2 in
            row1 / row2  // Uses vector division
        }
    }
}

// MARK: - Matrix Arithmetic Operations (Float)

public extension Array where Element == [Float] {
    /// Element-wise addition of two matrices
    /// - Parameters:
    ///   - lhs: The first matrix
    ///   - rhs: The second matrix
    /// - Returns: A new matrix where each element is the sum of corresponding elements
    static func + (lhs: [[Float]], rhs: [[Float]]) -> [[Float]] {
        precondition(lhs.count == rhs.count, "Matrices must have same number of rows")
        precondition(!lhs.isEmpty, "Cannot add empty matrices")

        return zip(lhs, rhs).map { row1, row2 in
            row1 + row2  // Uses vector addition
        }
    }

    /// Element-wise subtraction of two matrices
    /// - Parameters:
    ///   - lhs: The first matrix
    ///   - rhs: The second matrix
    /// - Returns: A new matrix where each element is the difference of corresponding elements
    static func - (lhs: [[Float]], rhs: [[Float]]) -> [[Float]] {
        precondition(lhs.count == rhs.count, "Matrices must have same number of rows")
        precondition(!lhs.isEmpty, "Cannot subtract empty matrices")

        return zip(lhs, rhs).map { row1, row2 in
            row1 - row2  // Uses vector subtraction
        }
    }

    /// Element-wise multiplication of two matrices (Hadamard product)
    /// - Parameters:
    ///   - lhs: The first matrix
    ///   - rhs: The second matrix
    /// - Returns: A new matrix where each element is the product of corresponding elements
    static func * (lhs: [[Float]], rhs: [[Float]]) -> [[Float]] {
        precondition(lhs.count == rhs.count, "Matrices must have same number of rows")
        precondition(!lhs.isEmpty, "Cannot multiply empty matrices")

        return zip(lhs, rhs).map { row1, row2 in
            row1 * row2  // Uses vector multiplication
        }
    }

    /// Element-wise division of two matrices
    /// - Parameters:
    ///   - lhs: The first matrix
    ///   - rhs: The second matrix
    /// - Returns: A new matrix where each element is the quotient of corresponding elements
    static func / (lhs: [[Float]], rhs: [[Float]]) -> [[Float]] {
        precondition(lhs.count == rhs.count, "Matrices must have same number of rows")
        precondition(!lhs.isEmpty, "Cannot divide empty matrices")

        return zip(lhs, rhs).map { row1, row2 in
            row1 / row2  // Uses vector division
        }
    }
}
