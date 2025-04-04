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

// MARK: - Random Array Generation for Double

public extension Array where Element == Double {
    /// Creates a 1D array of random values uniformly distributed between 0 and 1
    static func random(_ count: Int) -> [Double] {
        precondition(count >= 0, "Count must be non-negative")
        return (0..<count).map { _ in Double.random(in: 0...1) }
    }
    
    /// Creates a 2D array of random values uniformly distributed between 0 and 1
    static func random(_ rows: Int, _ columns: Int) -> [[Double]] {
        precondition(rows > 0 && columns > 0, "Dimensions must be positive")
        return (0..<rows).map { _ in (0..<columns).map { _ in Double.random(in: 0...1) } }
    }
}

// MARK: - Random Array Generation for Float

public extension Array where Element == Float {
    /// Creates a 1D array of random values uniformly distributed between 0 and 1
    static func random(_ count: Int) -> [Float] {
        precondition(count >= 0, "Count must be non-negative")
        return (0..<count).map { _ in Float.random(in: 0...1) }
    }
    
    /// Creates a 2D array of random values uniformly distributed between 0 and 1
    static func random(_ rows: Int, _ columns: Int) -> [[Float]] {
        precondition(rows > 0 && columns > 0, "Dimensions must be positive")
        return (0..<rows).map { _ in (0..<columns).map { _ in Float.random(in: 0...1) } }
    }
}
