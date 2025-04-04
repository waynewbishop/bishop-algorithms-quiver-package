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

/// Internal vector implementation for comparable elements in the Quiver framework
internal struct _VectorComparable<Element: Comparable> {
    /// The elements of the vector
    var elements: [Element]
    
    /// Initialize a vector with the given elements
    init(elements: [Element]) {
        self.elements = elements
    }
    
    /// Checks if this vector is equal to another vector element-wise
    func isEqual(to other: _VectorComparable<Element>) -> [Bool] {
        precondition(elements.count == other.elements.count, "Vectors must have the same dimension")
        
        var result = [Bool]()
        for i in 0..<elements.count {
            result.append(elements[i] == other.elements[i])
        }
        return result
    }
    
    /// Checks if each element in this vector is greater than a value
    func isGreaterThan(_ value: Element) -> [Bool] {
        return elements.map { $0 > value }
    }
    
    /// Checks if each element in this vector is less than a value
    func isLessThan(_ value: Element) -> [Bool] {
        return elements.map { $0 < value }
    }
    
    /// Checks if each element in this vector is greater than or equal to a value
    func isGreaterThanOrEqual(_ value: Element) -> [Bool] {
        return elements.map { $0 >= value }
    }
    
    /// Checks if each element in this vector is less than or equal to a value
    func isLessThanOrEqual(_ value: Element) -> [Bool] {
        return elements.map { $0 <= value }
    }
}
