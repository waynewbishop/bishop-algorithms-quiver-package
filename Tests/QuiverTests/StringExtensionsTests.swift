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

import XCTest
@testable import Quiver

final class StringExtensionsTests: XCTestCase {

    // MARK: - Tokenize Tests

    func testTokenizeBasicText() {
        let text = "Comfortable Running Shoes"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["comfortable", "running", "shoes"])
    }

    func testTokenizeLowercaseConversion() {
        let text = "UPPERCASE lowercase MixedCase"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["uppercase", "lowercase", "mixedcase"])
    }

    // Covers multiple spaces, newlines, mixed whitespace, leading/trailing whitespace
    func testTokenizeWhitespaceHandling() {
        XCTAssertEqual("word1    word2     word3".tokenize(), ["word1", "word2", "word3"])
        XCTAssertEqual("line1\nline2\nline3".tokenize(), ["line1", "line2", "line3"])
        XCTAssertEqual("word1  \n  word2\t\tword3\r\nword4".tokenize(),
                        ["word1", "word2", "word3", "word4"])
        XCTAssertEqual("  leading and trailing  ".tokenize(), ["leading", "and", "trailing"])
    }

    // Covers empty string, whitespace-only, single word
    func testTokenizeEdgeCases() {
        XCTAssertEqual("".tokenize(), [])
        XCTAssertEqual("   \n\t  \r\n  ".tokenize(), [])
        XCTAssertEqual("word".tokenize(), ["word"])
    }

    func testTokenizeWithPunctuation() {
        let text = "Hello, world! How are you?"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["hello,", "world!", "how", "are", "you?"])
    }

    func testTokenizeSemanticSearchExample() {
        let text = "lightweight cushioned running shoes"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["lightweight", "cushioned", "running", "shoes"])
        XCTAssertEqual(tokens.count, 4)
    }

    // MARK: - Embed Tests

    func testEmbedBasicLookup() {
        let words = ["running", "shoes"]
        let embeddings = [
            "running": [0.8, 0.7, 0.9],
            "shoes": [0.1, 0.9, 0.2]
        ]

        let vectors = words.embed(using: embeddings)

        XCTAssertEqual(vectors.count, 2)
        XCTAssertEqual(vectors[0], [0.8, 0.7, 0.9])
        XCTAssertEqual(vectors[1], [0.1, 0.9, 0.2])
    }

    func testEmbedWithUnknownWords() {
        let words = ["running", "unknown", "shoes"]
        let embeddings = [
            "running": [0.8, 0.7, 0.9],
            "shoes": [0.1, 0.9, 0.2]
        ]

        let vectors = words.embed(using: embeddings)

        XCTAssertEqual(vectors.count, 2)
        XCTAssertEqual(vectors[0], [0.8, 0.7, 0.9])
        XCTAssertEqual(vectors[1], [0.1, 0.9, 0.2])
    }

    // Covers empty array and no matches
    func testEmbedEdgeCases() {
        let embeddings = [
            "running": [0.8, 0.7, 0.9],
            "shoes": [0.1, 0.9, 0.2]
        ]

        XCTAssertEqual([String]().embed(using: embeddings).count, 0)
        XCTAssertEqual(["unknown1", "unknown2"].embed(using: embeddings).count, 0)
    }

    func testEmbedIntegrationWithTokenize() {
        let text = "running shoes"
        let embeddings = [
            "running": [0.8, 0.7, 0.9],
            "shoes": [0.1, 0.9, 0.2]
        ]

        let vectors = text.tokenize().embed(using: embeddings)

        XCTAssertEqual(vectors.count, 2)
        XCTAssertEqual(vectors[0], [0.8, 0.7, 0.9])
        XCTAssertEqual(vectors[1], [0.1, 0.9, 0.2])
    }
}
