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

// MARK: - Array Information Numeric Types

public extension Array where Element: Numeric {
    /// Prints basic information about the array
    func info() -> String {
        var result = "Array Information:\n"
        result += "Count: \(self.count)\n"
        result += "Shape: \(self.shape)\n"
        result += "Type: \(type(of: Element.self))\n"
        
        // Show a few items if not empty
        if !self.isEmpty {
            let previewCount = Swift.min(5, self.count)
            result += "\nFirst \(previewCount) items:\n"
            for i in 0..<previewCount {
                result += "[\(i)]: \(self[i])\n"
            }
        }
        
        return result
    }
}

// MARK: - Array Information Floating Point Types

public extension Array where Element: FloatingPoint {
    /// Prints basic information and statistics about the numeric array
    func info() -> String {
        var result = "Array Information:\n"
        result += "Count: \(self.count)\n"
        result += "Shape: \(self.shape)\n"
        result += "Type: \(type(of: Element.self))\n"
        
        // Add basic statistics if not empty
        if !self.isEmpty {
            if let mean = self.mean() {
                result += "Mean: \(mean)\n"
            }
            if let min = self.min() {
                result += "Min: \(min)\n"
            }
            if let max = self.max() {
                result += "Max: \(max)\n"
            }
            
            // Show a few items
            let previewCount = Swift.min(5, self.count)
            result += "\nFirst \(previewCount) items:\n"
            for i in 0..<previewCount {
                result += "[\(i)]: \(self[i])\n"
            }
        }
        
        return result
    }
}
