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

// MARK: - Element-wise Operations for Double Arrays

public extension Array where Element == Double {
    /// Raises each element to the specified power.
    ///
    /// - Parameter exponent: The power to raise each element to (supports fractional and negative values)
    /// - Returns: A new array where each element is raised to the given exponent
    func power(_ exponent: Double) -> [Double] {
        return self.map { Foundation.pow($0, exponent) }
    }

    /// Returns the sine of each element in the array.
    ///
    /// - Returns: A new array of sine values, with inputs interpreted as radians
    func sin() -> [Double] {
        return self.map { Foundation.sin($0) }
    }

    /// Returns the cosine of each element in the array.
    ///
    /// - Returns: A new array of cosine values, with inputs interpreted as radians
    func cos() -> [Double] {
        return self.map { Foundation.cos($0) }
    }

    /// Returns the tangent of each element in the array.
    ///
    /// - Returns: A new array of tangent values, with inputs interpreted as radians
    func tan() -> [Double] {
        return self.map { Foundation.tan($0) }
    }

    /// Returns the floor of each element in the array.
    ///
    /// - Returns: A new array where each element is rounded down to the nearest integer
    func floor() -> [Double] {
        return self.map { Foundation.floor($0) }
    }

    /// Returns the ceiling of each element in the array.
    ///
    /// - Returns: A new array where each element is rounded up to the nearest integer
    func ceil() -> [Double] {
        return self.map { Foundation.ceil($0) }
    }

    /// Returns the rounded value of each element in the array.
    ///
    /// - Returns: A new array where each element is rounded to the nearest integer
    func round() -> [Double] {
        return self.map { Foundation.round($0) }
    }

    /// Returns the natural logarithm of each element in the array.
    ///
    /// - Returns: A new array of natural log values (base e)
    func log() -> [Double] {
        return self.map { Foundation.log($0) }
    }

    /// Returns the base-10 logarithm of each element in the array.
    ///
    /// - Returns: A new array of base-10 log values
    func log10() -> [Double] {
        return self.map { Foundation.log10($0) }
    }

    /// Returns e raised to the power of each element in the array.
    ///
    /// - Returns: A new array where each element is the exponential e^x
    func exp() -> [Double] {
        return self.map { Foundation.exp($0) }
    }

    /// Returns the square root of each element in the array.
    ///
    /// - Returns: A new array of square root values
    func sqrt() -> [Double] {
        return self.map { Foundation.sqrt($0) }
    }

    /// Returns the square of each element in the array.
    ///
    /// - Returns: A new array where each element is multiplied by itself
    func square() -> [Double] {
        return self.map { $0 * $0 }
    }
}

// MARK: - Element-wise Operations for Float Arrays

public extension Array where Element == Float {
    /// Raises each element to the specified power.
    ///
    /// - Parameter exponent: The power to raise each element to (supports fractional and negative values)
    /// - Returns: A new array where each element is raised to the given exponent
    func power(_ exponent: Float) -> [Float] {
        return self.map { Foundation.powf($0, exponent) }
    }

    /// Returns the sine of each element in the array.
    ///
    /// - Returns: A new array of sine values, with inputs interpreted as radians
    func sin() -> [Float] {
        return self.map { Foundation.sinf($0) }
    }

    /// Returns the cosine of each element in the array.
    ///
    /// - Returns: A new array of cosine values, with inputs interpreted as radians
    func cos() -> [Float] {
        return self.map { Foundation.cosf($0) }
    }

    /// Returns the tangent of each element in the array.
    ///
    /// - Returns: A new array of tangent values, with inputs interpreted as radians
    func tan() -> [Float] {
        return self.map { Foundation.tanf($0) }
    }

    /// Returns the floor of each element in the array.
    ///
    /// - Returns: A new array where each element is rounded down to the nearest integer
    func floor() -> [Float] {
        return self.map { Foundation.floorf($0) }
    }

    /// Returns the ceiling of each element in the array.
    ///
    /// - Returns: A new array where each element is rounded up to the nearest integer
    func ceil() -> [Float] {
        return self.map { Foundation.ceilf($0) }
    }

    /// Returns the rounded value of each element in the array.
    ///
    /// - Returns: A new array where each element is rounded to the nearest integer
    func round() -> [Float] {
        return self.map { Foundation.roundf($0) }
    }

    /// Returns the natural logarithm of each element in the array.
    ///
    /// - Returns: A new array of natural log values (base e)
    func log() -> [Float] {
        return self.map { Foundation.logf($0) }
    }

    /// Returns the base-10 logarithm of each element in the array.
    ///
    /// - Returns: A new array of base-10 log values
    func log10() -> [Float] {
        return self.map { Foundation.log10f($0) }
    }

    /// Returns e raised to the power of each element in the array.
    ///
    /// - Returns: A new array where each element is the exponential e^x
    func exp() -> [Float] {
        return self.map { Foundation.expf($0) }
    }

    /// Returns the square root of each element in the array.
    ///
    /// - Returns: A new array of square root values
    func sqrt() -> [Float] {
        return self.map { Foundation.sqrtf($0) }
    }

    /// Returns the square of each element in the array.
    ///
    /// - Returns: A new array where each element is multiplied by itself
    func square() -> [Float] {
        return self.map { $0 * $0 }
    }
}
