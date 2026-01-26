// Copyright 2025 Wayne W Bishop. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

public extension String {

    /// Tokenizes text into individual words for text analysis and embedding workflows.
    ///
    /// This method converts text to lowercase, splits on whitespace and newlines,
    /// and filters out empty strings. It provides basic tokenization suitable for
    /// word embeddings, semantic search, and natural language processing tasks.
    ///
    /// Example:
    /// ```swift
    /// let text = "Comfortable Running Shoes"
    /// let words = text.tokenize()  // ["comfortable", "running", "shoes"]
    /// ```
    ///
    /// - Returns: An array of lowercase word tokens with empty strings removed
    func tokenize() -> [String] {
        return self.lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
    }
}

public extension Array where Element == String {

    /// Converts an array of words to their vector embeddings by looking up each word in the embeddings dictionary.
    ///
    /// This method looks up each word in the provided embeddings dictionary and returns only
    /// the vectors for words that exist in the dictionary. Words not found are automatically
    /// filtered out, making it safe to use with any vocabulary.
    ///
    /// Example:
    /// ```swift
    /// let words = ["running", "shoes", "unknown"]
    /// let embeddings = [
    ///     "running": [0.8, 0.7, 0.9],
    ///     "shoes": [0.1, 0.9, 0.2]
    /// ]
    /// let vectors = words.embed(using: embeddings)
    /// // Returns: [[0.8, 0.7, 0.9], [0.1, 0.9, 0.2]]
    /// // "unknown" is filtered out
    /// ```
    ///
    /// - Parameter embeddings: Dictionary mapping words to their vector representations
    /// - Returns: Array of vectors for words found in the embeddings dictionary
    func embed(using embeddings: [String: [Double]]) -> [[Double]] {
        return self.compactMap { embeddings[$0] }
    }
}
