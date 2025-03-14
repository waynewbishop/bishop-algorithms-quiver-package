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
