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

    func testTokenizeWithMultipleSpaces() {
        let text = "word1    word2     word3"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["word1", "word2", "word3"])
    }

    func testTokenizeWithNewlines() {
        let text = "line1\nline2\nline3"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["line1", "line2", "line3"])
    }

    func testTokenizeWithMixedWhitespace() {
        let text = "word1  \n  word2\t\tword3\r\nword4"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["word1", "word2", "word3", "word4"])
    }

    func testTokenizeEmptyString() {
        let text = ""
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, [])
    }

    func testTokenizeWhitespaceOnly() {
        let text = "   \n\t  \r\n  "
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, [])
    }

    func testTokenizeSingleWord() {
        let text = "word"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["word"])
    }

    func testTokenizeWithLeadingTrailingWhitespace() {
        let text = "  leading and trailing  "
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["leading", "and", "trailing"])
    }

    func testTokenizeWithPunctuation() {
        // Note: This is basic tokenization, doesn't strip punctuation
        let text = "Hello, world! How are you?"
        let tokens = text.tokenize()

        XCTAssertEqual(tokens, ["hello,", "world!", "how", "are", "you?"])
    }

    func testTokenizeSemanticSearchExample() {
        // Real-world example from Chapter 23
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

        // "unknown" should be filtered out
        XCTAssertEqual(vectors.count, 2)
        XCTAssertEqual(vectors[0], [0.8, 0.7, 0.9])
        XCTAssertEqual(vectors[1], [0.1, 0.9, 0.2])
    }

    func testEmbedEmptyArray() {
        let words: [String] = []
        let embeddings = [
            "running": [0.8, 0.7, 0.9]
        ]

        let vectors = words.embed(using: embeddings)

        XCTAssertEqual(vectors.count, 0)
    }

    func testEmbedNoMatches() {
        let words = ["unknown1", "unknown2"]
        let embeddings = [
            "running": [0.8, 0.7, 0.9],
            "shoes": [0.1, 0.9, 0.2]
        ]

        let vectors = words.embed(using: embeddings)

        XCTAssertEqual(vectors.count, 0)
    }

    func testEmbedAllMatches() {
        let words = ["running", "jogging", "shoes", "sneakers"]
        let embeddings = [
            "running": [0.8, 0.7, 0.9, 0.2],
            "jogging": [0.8, 0.7, 0.8, 0.2],
            "shoes": [0.1, 0.9, 0.2, 0.1],
            "sneakers": [0.1, 0.9, 0.3, 0.1]
        ]

        let vectors = words.embed(using: embeddings)

        XCTAssertEqual(vectors.count, 4)
        XCTAssertEqual(vectors[0], [0.8, 0.7, 0.9, 0.2])
        XCTAssertEqual(vectors[1], [0.8, 0.7, 0.8, 0.2])
        XCTAssertEqual(vectors[2], [0.1, 0.9, 0.2, 0.1])
        XCTAssertEqual(vectors[3], [0.1, 0.9, 0.3, 0.1])
    }

    func testEmbedIntegrationWithTokenize() {
        // Full workflow: text -> tokens -> vectors
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
