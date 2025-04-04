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

// MARK: - Array Generation for Numeric Types

public extension Array where Element: Numeric {
    /// Creates a 1D array filled with zeros
    static func zeros(_ count: Int) -> [Element] {
        return _Vector<Element>.zeros(count).elements
    }
    
    /// Creates a 1D array filled with ones
    static func ones(_ count: Int) -> [Element] {
        return _Vector<Element>.ones(count).elements
    }
    
    /// Creates a 1D array filled with a specific value
    static func full(_ count: Int, value: Element) -> [Element] {
        return _Vector<Element>.full(count, value: value).elements
    }
    
    /// Creates a 2D array filled with zeros
    static func zeros(_ rows: Int, _ columns: Int) -> [[Element]] {
        return _Vector<Element>.zeros2D(rows, columns)
    }
    
    /// Creates a 2D array filled with ones
    static func ones(_ rows: Int, _ columns: Int) -> [[Element]] {
        return _Vector<Element>.ones2D(rows, columns)
    }
    
    /// Creates a 2D array filled with a specific value
    static func full(_ rows: Int, _ columns: Int, value: Element) -> [[Element]] {
        return _Vector<Element>.full2D(rows, columns, value: value)
    }
    
    /// Creates a 2D identity matrix of size n x n
    static func identity(_ n: Int) -> [[Element]] {
        return _Vector<Element>.identity(n)
    }
    
    /// Creates a diagonal matrix from a 1D array
    static func diag(_ diagonal: [Element]) -> [[Element]] {
        return _Vector<Element>.diag(_Vector(elements: diagonal))
    }
    
    /// Creates a sequence of values with a specified step size
    static func arange(_ start: Element, _ stop: Element, step: Element) -> [Element] where Element: Comparable {
        var result = [Element]()
        
        if step > .zero {
            var current = start
            while current < stop {
                result.append(current)
                current = current + step
            }
        } else if step < .zero {
            var current = start
            while current > stop {
                result.append(current)
                current = current + step
            }
        } else {
            preconditionFailure("Step size cannot be zero")
        }
        
        return result
    }
}

// MARK: - Array Generation for FloatingPoint Types

public extension Array where Element: FloatingPoint {
    /// Creates evenly spaced numbers over a specified interval
    static func linspace(_ start: Element, _ stop: Element, num: Int) -> [Element] {
        return _Vector<Element>.linspace(start, stop, num: num).elements
    }
    
    /// Creates a sequence of values with a specified step size
    static func arange(_ start: Element, _ stop: Element, step: Element = 1) -> [Element] {
        return _Vector<Element>.arange(start, stop, step: step).elements
    }
    
}
