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

// MARK: - Reshape Operations

extension _Vector where Element: Numeric {

    /// Reshapes a one-dimensional array into a two-dimensional matrix using row-major order.
    ///
    /// Elements are placed into the result matrix row by row, filling each row from left
    /// to right before moving to the next row. This matches C-style (row-major) memory
    /// layout and is consistent with how Swift stores nested arrays.
    ///
    /// The total number of elements must equal `rows × columns`. For example, an array
    /// of 12 elements can be reshaped to 3×4, 4×3, 2×6, 6×2, 1×12, or 12×1.
    ///
    /// - Parameters:
    ///   - elements: The source array to reshape.
    ///   - rows: The number of rows in the resulting matrix (must be positive).
    ///   - columns: The number of columns in the resulting matrix (must be positive).
    /// - Returns: A two-dimensional array with the specified dimensions.
    static func reshape(_ elements: [Element], rows: Int, columns: Int) -> [[Element]] {
        precondition(rows > 0 && columns > 0, "Dimensions must be positive")
        precondition(elements.count == rows * columns,
            "Cannot reshape array of \(elements.count) elements into \(rows)×\(columns) matrix")

        var result = [[Element]]()
        for i in 0..<rows {
            let start = i * columns
            let row = Array(elements[start..<start + columns])
            result.append(row)
        }
        return result
    }

    /// Flattens a two-dimensional matrix into a one-dimensional array using row-major order.
    ///
    /// Rows are concatenated sequentially — all elements from the first row appear first,
    /// followed by all elements from the second row, and so on. This is the inverse of
    /// `reshape` and produces an array whose element count equals `rows × columns`.
    ///
    /// Returns an empty array if the input matrix is empty.
    ///
    /// - Parameter matrix: The two-dimensional array to flatten.
    /// - Returns: A one-dimensional array containing all matrix elements in row-major order.
    static func flatten(_ matrix: [[Element]]) -> [Element] {
        guard !matrix.isEmpty else { return [] }

        var result = [Element]()
        for row in matrix {
            result.append(contentsOf: row)
        }
        return result
    }
}
