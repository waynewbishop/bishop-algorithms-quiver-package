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

// MARK: - Broadcasting for scalar operations on 1D arrays

public extension Array where Element: Numeric {
    /// Broadcasts a scalar addition operation to each element
    /// - Parameter value: The scalar value to add to each element
    /// - Returns: A new array with the scalar added to each element
    func broadcast(adding value: Element) -> [Element] {
        return self.map { $0 + value }
    }
    
    /// Broadcasts a scalar multiplication operation to each element
    /// - Parameter value: The scalar value to multiply each element by
    /// - Returns: A new array with each element multiplied by the scalar
    func broadcast(multiplyingBy value: Element) -> [Element] {
        return self.map { $0 * value }
    }
    
    /// Broadcasts a scalar subtraction operation to each element
    /// - Parameter value: The scalar value to subtract from each element
    /// - Returns: A new array with the scalar subtracted from each element
    func broadcast(subtracting value: Element) -> [Element] {
        return self.map { $0 - value }
    }
}

// Add division only for floating point types
public extension Array where Element: FloatingPoint {
    /// Broadcasts a scalar division operation to each element
    /// - Parameter value: The scalar value to divide each element by
    /// - Returns: A new array with each element divided by the scalar
    func broadcast(dividingBy value: Element) -> [Element] {
        precondition(value != 0, "Cannot divide by zero")
        return self.map { $0 / value }
    }
}

// MARK: - Broadcasting for array operations on 2D arrays

public extension Array where Element: Collection, Element.Element: Numeric {
    /// Broadcasts a row vector across each row of the matrix
    /// - Parameter vector: The vector to add to each row
    /// - Returns: A new matrix with the vector added to each row
    func broadcast(addingToEachRow vector: [Element.Element]) -> [[Element.Element]] {
        // Convert self to [[Element.Element]] for easier manipulation
        let matrix = self.map { Swift.Array($0) }
        
        // Verify dimensions
        guard let firstRow = matrix.first, firstRow.count == vector.count else {
            preconditionFailure("Row vector length must match matrix column count")
        }
        
        // Add the vector to each row
        return matrix.map { row in
            zip(row, vector).map { $0 + $1 }
        }
    }
    
    /// Broadcasts a column vector across each column of the matrix
    /// - Parameter vector: The vector to add to each column
    /// - Returns: A new matrix with the vector added to each column
    func broadcast(addingToEachColumn vector: [Element.Element]) -> [[Element.Element]] {
        // Convert self to [[Element.Element]] for easier manipulation
        let matrix = self.map { Swift.Array($0) }
        
        // Verify dimensions
        guard matrix.count == vector.count else {
            preconditionFailure("Column vector length must match matrix row count")
        }
        
        // Add the corresponding vector element to each element in a row
        return matrix.enumerated().map { rowIndex, row in
            return row.map { $0 + vector[rowIndex] }
        }
    }
    
    /// Broadcasts a row vector multiplication across each row of the matrix
    /// - Parameter vector: The vector to multiply each row by
    /// - Returns: A new matrix with each row multiplied by the vector
    func broadcast(multiplyingEachRowBy vector: [Element.Element]) -> [[Element.Element]] {
        // Convert self to [[Element.Element]] for easier manipulation
        let matrix = self.map { Swift.Array($0) }
        
        // Verify dimensions
        guard let firstRow = matrix.first, firstRow.count == vector.count else {
            preconditionFailure("Row vector length must match matrix column count")
        }
        
        // Multiply each row by the vector
        return matrix.map { row in
            zip(row, vector).map { $0 * $1 }
        }
    }
    
    /// Broadcasts a column vector multiplication across each column of the matrix
    /// - Parameter vector: The vector to multiply each column by
    /// - Returns: A new matrix with each column multiplied by the vector
    func broadcast(multiplyingEachColumnBy vector: [Element.Element]) -> [[Element.Element]] {
        // Convert self to [[Element.Element]] for easier manipulation
        let matrix = self.map { Swift.Array($0) }
        
        // Verify dimensions
        guard matrix.count == vector.count else {
            preconditionFailure("Column vector length must match matrix row count")
        }
        
        // Multiply each element in a row by the corresponding vector element
        return matrix.enumerated().map { rowIndex, row in
            return row.map { $0 * vector[rowIndex] }
        }
    }
}

// MARK: - General broadcasting with closure

public extension Array where Element: Numeric {
    /// Broadcasts a custom operation with a scalar value to each element
    /// - Parameters:
    ///   - value: The scalar value to use in the operation
    ///   - operation: A closure that defines the operation to perform
    /// - Returns: A new array with the operation applied to each element
    func broadcast(with value: Element, operation: (Element, Element) -> Element) -> [Element] {
        return self.map { operation($0, value) }
    }
}

public extension Array where Element: Collection, Element.Element: Numeric {
    /// Broadcasts a custom row operation across the matrix
    /// - Parameters:
    ///   - vector: The vector to use in the operation
    ///   - operation: A closure that defines the operation to perform
    /// - Returns: A new matrix with the operation applied to each row
    func broadcast(withRowVector vector: [Element.Element],
                  operation: (Element.Element, Element.Element) -> Element.Element) -> [[Element.Element]] {
        // Convert self to [[Element.Element]] for easier manipulation
        let matrix = self.map { Swift.Array($0) }
        
        // Verify dimensions
        guard let firstRow = matrix.first, firstRow.count == vector.count else {
            preconditionFailure("Row vector length must match matrix column count")
        }
        
        // Apply operation between each row and the vector
        return matrix.map { row in
            zip(row, vector).map { operation($0, $1) }
        }
    }
    
    /// Broadcasts a custom column operation across the matrix
    /// - Parameters:
    ///   - vector: The vector to use in the operation
    ///   - operation: A closure that defines the operation to perform
    /// - Returns: A new matrix with the operation applied to each column
    func broadcast(withColumnVector vector: [Element.Element],
                  operation: (Element.Element, Element.Element) -> Element.Element) -> [[Element.Element]] {
        // Convert self to [[Element.Element]] for easier manipulation
        let matrix = self.map { Swift.Array($0) }
        
        // Verify dimensions
        guard matrix.count == vector.count else {
            preconditionFailure("Column vector length must match matrix row count")
        }
        
        // Apply operation between each element and the corresponding vector element
        return matrix.enumerated().map { rowIndex, row in
            return row.map { operation($0, vector[rowIndex]) }
        }
    }
}
