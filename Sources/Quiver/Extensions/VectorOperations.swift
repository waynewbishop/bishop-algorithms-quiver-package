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

// MARK: - Vector Operations

public extension Array where Element: Numeric {
    /// Calculates the dot product of two vectors
    func dot(_ other: [Element]) -> Element {
        let v1 = _Vector(elements: self)
        let v2 = _Vector(elements: other)
        return _Vector.dot(v1, v2)
    }
}

// MARK: - FloatingPoint Vector Operations

public extension Array where Element: FloatingPoint {
    /// Calculates the magnitude (length) of the vector
    var magnitude: Element {
        let v = _Vector(elements: self)
        return v.magnitude()
    }
    
    /// Returns a normalized version of the vector (unit vector)
    var normalized: [Element] {
        let v = _Vector(elements: self)
        return v.normalized().elements
    }
    
    /// Returns the cosine of the angle between two vectors
    func cosineAngle(with other: [Element]) -> Element {
        let dotProduct = self.dot(other)
        let magnitudeProduct = self.magnitude * other.magnitude
        
        precondition(magnitudeProduct > 0, "Cannot calculate angle with zero vector")
        return dotProduct / magnitudeProduct
    }

    /// Calculates the scalar projection of this vector onto another vector
    ///
    /// The scalar projection represents the length of the shadow cast by this vector
    /// onto the direction of the other vector.
    ///
    /// - Parameter vector: The vector to project onto
    /// - Returns: The scalar projection value
    func scalarProjection(onto vector: [Element]) -> Element {
        let v1 = _Vector(elements: self)
        let v2 = _Vector(elements: vector)
        return v1.scalarProjection(onto: v2)
    }
    
    /// Calculates the vector projection of this vector onto another vector
    ///
    /// The vector projection is the vector component of this vector
    /// in the direction of the other vector.
    ///
    /// - Parameter vector: The vector to project onto
    /// - Returns: The projected vector
    func vectorProjection(onto vector: [Element]) -> [Element] {
        let v1 = _Vector(elements: self)
        let v2 = _Vector(elements: vector)
        return v1.vectorProjection(onto: v2).elements
    }
    
    /// Returns the orthogonal component of this vector with respect to another vector
    ///
    /// This returns the component of this vector that is perpendicular to the other vector.
    ///
    /// - Parameter vector: The reference vector
    /// - Returns: The orthogonal component
    func orthogonalComponent(to vector: [Element]) -> [Element] {
        let projection = self.vectorProjection(onto: vector)
        return self - projection
    }
}
