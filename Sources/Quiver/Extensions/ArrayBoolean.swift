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

// MARK: - Boolean Comparison Operations

public extension Array where Element: Comparable {
    /// Checks if this array is equal to another array element-wise
    /// - Parameter other: The array to compare with
    /// - Returns: An array of boolean values indicating equality at each position
    func isEqual(to other: [Element]) -> [Bool] {
        let v1 = _VectorComparable(elements: self)
        let v2 = _VectorComparable(elements: other)
        return v1.isEqual(to: v2)
    }
    
    /// Checks if each element in this array is greater than the specified value
    /// - Parameter value: The value to compare against
    /// - Returns: An array of boolean values
    func isGreaterThan(_ value: Element) -> [Bool] {
        let vector = _VectorComparable(elements: self)
        return vector.isGreaterThan(value)
    }
    
    /// Checks if each element in this array is less than the specified value
    /// - Parameter value: The value to compare against
    /// - Returns: An array of boolean values
    func isLessThan(_ value: Element) -> [Bool] {
        let vector = _VectorComparable(elements: self)
        return vector.isLessThan(value)
    }
    
    /// Checks if each element in this array is greater than or equal to the specified value
    /// - Parameter value: The value to compare against
    /// - Returns: An array of boolean values
    func isGreaterThanOrEqual(_ value: Element) -> [Bool] {
        let vector = _VectorComparable(elements: self)
        return vector.isGreaterThanOrEqual(value)
    }
    
    /// Checks if each element in this array is less than or equal to the specified value
    /// - Parameter value: The value to compare against
    /// - Returns: An array of boolean values
    func isLessThanOrEqual(_ value: Element) -> [Bool] {
        let vector = _VectorComparable(elements: self)
        return vector.isLessThanOrEqual(value)
    }
}

// Helper extension for Boolean arrays
public extension Array where Element == Bool {
    /// Returns the indices where the elements are true
    var trueIndices: [Int] {
        return self.enumerated()
                  .filter { $0.element }
                  .map { $0.offset }
    }

    /// Performs logical AND with another boolean array
    func and(_ other: [Bool]) -> [Bool] {
        precondition(self.count == other.count, "Arrays must have the same length")
        return zip(self, other).map { $0 && $1 }
    }
    
    /// Performs logical OR with another boolean array
    func or(_ other: [Bool]) -> [Bool] {
        precondition(self.count == other.count, "Arrays must have the same length")
        return zip(self, other).map { $0 || $1 }
    }
    
    /// Performs logical NOT on the boolean array
    var not: [Bool] {
        return self.map { !$0 }
    }
}

// MARK: - Boolean Indexing
public extension Array {
    /// Returns elements where the mask is true (like NumPy's array[mask])
    /// - Parameter mask: The boolean mask to apply
    /// - Returns: Array containing only elements where the mask is true
    func masked(by mask: [Bool]) -> [Element] {
        precondition(self.count == mask.count, "Array and mask must have the same length")
        return zip(self, mask)
            .filter { $0.1 }
            .map { $0.0 }
    }
    
    /// Returns a new array with elements conditionally chosen from this array or another
    /// - Parameters:
    ///   - condition: Boolean mask determining which array to choose from
    ///   - other: The alternative array to choose elements from when condition is false
    /// - Returns: Array with elements chosen conditionally from this array or other
    func choose(where condition: [Bool], otherwise other: [Element]) -> [Element] {
        precondition(self.count == condition.count && self.count == other.count,
                     "All arrays must have the same length")
        return zip(self, zip(condition, other))
            .map { $0.1.0 ? $0.0 : $0.1.1 }
    }
}
