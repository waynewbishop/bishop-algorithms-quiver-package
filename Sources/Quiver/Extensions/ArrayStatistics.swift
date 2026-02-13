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

    /// Detect outliers using the z-score method
    /// - Parameters:
    ///   - threshold: Number of standard deviations from mean to consider an outlier (default: 2.0)
    ///   - mean: Pre-calculated mean (optional, calculated if nil)
    ///   - std: Pre-calculated standard deviation (optional, calculated if nil)
    /// - Returns: Boolean mask array where true indicates an outlier
    func outlierMask(threshold: Element = 2.0, mean: Element? = nil, std: Element? = nil) -> [Bool] {
        guard !self.isEmpty else { return [] }

        let computedMean = mean ?? self.mean() ?? 0
        let computedStd = std ?? self.std() ?? 1

        return self.map { abs($0 - computedMean) > threshold * computedStd }
    }
}

// MARK: - Vector Array Operations

public extension Array where Element == [Double] {
    /// Calculate the mean vector by averaging corresponding elements across all vectors
    ///
    /// This method computes the element-wise mean of multiple vectors, useful for:
    /// - Creating context vectors from word embeddings
    /// - Averaging feature vectors in machine learning
    /// - Computing centroids for clustering algorithms
    ///
    /// Example:
    /// ```swift
    /// let vectors = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
    /// let mean = vectors.meanVector()
    /// // Returns: [4.0, 5.0, 6.0]
    /// ```
    ///
    /// - Returns: A vector containing the mean of each dimension, or nil if array is empty or vectors have inconsistent dimensions
    func meanVector() -> [Double]? {
        guard !isEmpty else { return nil }
        guard let first = self.first else { return nil }

        let dimensions = first.count

        // Verify all vectors have the same dimensions
        guard self.allSatisfy({ $0.count == dimensions }) else {
            return nil
        }

        return (0..<dimensions).map { dim in
            self.map { $0[dim] }.mean() ?? 0.0
        }
    }
}

public extension Array where Element == [Float] {
    /// Calculate the mean vector by averaging corresponding elements across all vectors
    ///
    /// This method computes the element-wise mean of multiple vectors, useful for:
    /// - Creating context vectors from word embeddings
    /// - Averaging feature vectors in machine learning
    /// - Computing centroids for clustering algorithms
    ///
    /// Example:
    /// ```swift
    /// let vectors: [[Float]] = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
    /// let mean = vectors.meanVector()
    /// // Returns: [4.0, 5.0, 6.0]
    /// ```
    ///
    /// - Returns: A vector containing the mean of each dimension, or nil if array is empty or vectors have inconsistent dimensions
    func meanVector() -> [Float]? {
        guard !isEmpty else { return nil }
        guard let first = self.first else { return nil }

        let dimensions = first.count

        // Verify all vectors have the same dimensions
        guard self.allSatisfy({ $0.count == dimensions }) else {
            return nil
        }

        return (0..<dimensions).map { dim in
            self.map { $0[dim] }.mean() ?? 0.0
        }
    }
}
