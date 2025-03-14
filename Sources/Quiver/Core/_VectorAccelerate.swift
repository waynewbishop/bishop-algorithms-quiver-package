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
import Accelerate

// MARK: - Optimized implementations using Accelerate framework

extension _Vector where Element == Double {
    
    /// Optimized dot product implementation for Double vectors
    static func dot(_ lhs: _Vector<Double>, _ rhs: _Vector<Double>) -> Double {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result: Double = 0.0
        vDSP_dotprD(lhs.elements, 1, rhs.elements, 1, &result, vDSP_Length(lhs.elements.count))
        return result
    }
    
    /// Optimized magnitude calculation for Double vectors
    func magnitude() -> Double {
        var result: Double = 0.0
        vDSP_svesqD(elements, 1, &result, vDSP_Length(elements.count))
        return sqrt(result)
    }
    
    /// Optimized vector addition
    static func add(_ lhs: _Vector<Double>, _ rhs: _Vector<Double>) -> _Vector<Double> {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = [Double](repeating: 0.0, count: lhs.elements.count)
        vDSP_vaddD(lhs.elements, 1, rhs.elements, 1, &result, 1, vDSP_Length(lhs.elements.count))
        return _Vector(elements: result)
    }
    
    /// Optimized vector subtraction
    static func subtract(_ lhs: _Vector<Double>, _ rhs: _Vector<Double>) -> _Vector<Double> {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = [Double](repeating: 0.0, count: lhs.elements.count)
        vDSP_vsubD(rhs.elements, 1, lhs.elements, 1, &result, 1, vDSP_Length(lhs.elements.count))
        return _Vector(elements: result)
    }
    
    /// Optimized vector multiplication
    static func multiply(_ lhs: _Vector<Double>, _ rhs: _Vector<Double>) -> _Vector<Double> {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = [Double](repeating: 0.0, count: lhs.elements.count)
        vDSP_vmulD(lhs.elements, 1, rhs.elements, 1, &result, 1, vDSP_Length(lhs.elements.count))
        return _Vector(elements: result)
    }
    
    /// Optimized vector division
    static func divide(_ lhs: _Vector<Double>, _ rhs: _Vector<Double>) -> _Vector<Double> {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result = [Double](repeating: 0.0, count: lhs.elements.count)
        vDSP_vdivD(rhs.elements, 1, lhs.elements, 1, &result, 1, vDSP_Length(lhs.elements.count))
        return _Vector(elements: result)
    }
    
    /// Optimized vector normalization
    func normalized() -> _Vector<Double> {
        let mag = magnitude()
        precondition(mag > 0, "Cannot normalize a zero vector")
        
        var result = [Double](repeating: 0.0, count: elements.count)
        var scale = 1.0 / mag
        vDSP_vsmulD(elements, 1, &scale, &result, 1, vDSP_Length(elements.count))
        return _Vector(elements: result)
    }
}

// Similar optimizations for Float arrays
extension _Vector where Element == Float {
    /// Optimized dot product implementation for Float vectors
    static func dot(_ lhs: _Vector<Float>, _ rhs: _Vector<Float>) -> Float {
        precondition(lhs.elements.count == rhs.elements.count, "Vectors must have the same dimension")
        
        var result: Float = 0.0
        vDSP_dotpr(lhs.elements, 1, rhs.elements, 1, &result, vDSP_Length(lhs.elements.count))
        return result
    }
    
    /// Optimized magnitude calculation for Float vectors
    func magnitude() -> Float {
        var result: Float = 0.0
        vDSP_svesq(elements, 1, &result, vDSP_Length(elements.count))
        return sqrt(result)
    }
    
    // Add similar optimized implementations for other Float operations
}
