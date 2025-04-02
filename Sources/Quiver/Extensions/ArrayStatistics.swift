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

// MARK: - Basic Statistics for Numeric Types

public extension Array where Element: Numeric {
    /// Returns the sum of all elements in the array
    /// - Returns: The sum of all elements, or zero for an empty array
    func sum() -> Element {
        let vector = _Vector(elements: self)
        return vector.sum()
    }
    
    /// Returns the product of all elements in the array
    /// - Returns: The product of all elements, or the first element for an empty array
    func product() -> Element {
        let vector = _Vector(elements: self)
        return vector.product()
    }
    
    /// Returns the cumulative sum of elements in the array
    /// - Returns: An array where each element at index i is the sum of elements from 0 to i in the original array
    func cumulativeSum() -> [Element] {
        let vector = _Vector(elements: self)
        return vector.cumulativeSum().elements
    }
    
    /// Returns the cumulative product of elements in the array
    /// - Returns: An array where each element at index i is the product of elements from 0 to i in the original array
    func cumulativeProduct() -> [Element] {
        let vector = _Vector(elements: self)
        return vector.cumulativeProduct().elements
    }
}

// MARK: - Operations requiring comparison

public extension Array where Element: Numeric & Comparable {
    /// Returns the minimum element in the array
    /// - Returns: The minimum element, or nil if the array is empty
    func min() -> Element? {
        let vector = _Vector(elements: self)
        return vector.minWithIndex()?.value
    }
    
    /// Returns the maximum element in the array
    /// - Returns: The maximum element, or nil if the array is empty
    func max() -> Element? {
        let vector = _Vector(elements: self)
        return vector.maxWithIndex()?.value
    }
    
    /// Returns the index of the minimum element in the array
    /// - Returns: The index of the minimum element, or nil if the array is empty
    func argmin() -> Int? {
        let vector = _Vector(elements: self)
        return vector.minWithIndex()?.index
    }
    
    /// Returns the index of the maximum element in the array
    /// - Returns: The index of the maximum element, or nil if the array is empty
    func argmax() -> Int? {
        let vector = _Vector(elements: self)
        return vector.maxWithIndex()?.index
    }
}

// MARK: - Additional Statistics for FloatingPoint Types

public extension Array where Element: FloatingPoint {
    /// Returns the mean (average) of all elements in the array
    /// - Returns: The arithmetic mean of all elements, or nil if the array is empty
    func mean() -> Element? {
        let vector = _Vector(elements: self)
        return vector.mean()
    }
    
    /// Returns the median value of the array
    /// - Returns: The median value, or nil if the array is empty
    func median() -> Element? {
        let vector = _Vector(elements: self)
        return vector.median()
    }
    
    /// Returns the variance of all elements in the array
    /// - Parameter ddof: Delta Degrees of Freedom (0 for population, 1 for sample)
    /// - Returns: The variance, or nil if the array has fewer elements than ddof + 1
    func variance(ddof: Int = 0) -> Element? {
        let vector = _Vector(elements: self)
        return vector.variance(ddof: ddof)
    }
    
    /// Returns the standard deviation of all elements in the array
    /// - Parameter ddof: Delta Degrees of Freedom (0 for population, 1 for sample)
    /// - Returns: The standard deviation, or nil if the array has fewer elements than ddof + 1
    func std(ddof: Int = 0) -> Element? {
        let vector = _Vector(elements: self)
        return vector.std(ddof: ddof)
    }
    
}
