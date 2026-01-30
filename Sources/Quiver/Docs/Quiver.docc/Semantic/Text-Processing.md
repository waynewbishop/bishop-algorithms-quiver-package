# Text Processing

Convert text into numerical vectors for semantic search and natural language processing workflows.

## Overview

> Tip: For complete semantic search implementation examples including building a recommendation system, see [Chapter 23: Semantic Search](https://waynewbishop.github.io/swift-algorithms/23-semantic-search.html) in Swift Algorithms & Data Structures.

Quiver provides text processing extensions that enable natural language processing (NLP) workflows in Swift. These operations power semantic search systems, document similarity analysis, and recommendation engines by transforming text into numerical representations that can be mathematically compared.

This approach is fundamental to modern AI applications: instead of exact keyword matching, we represent text as vectors in high-dimensional space where similar meanings have similar numerical representations.

### The text-to-vector pipeline

Text processing in Quiver follows a three-step pipeline:

1. **Tokenization**: Break text into individual words
2. **Embedding**: Convert words to numerical vectors using pre-trained embeddings
3. **Aggregation**: Combine word vectors into document vectors

```swift
import Quiver

// Complete pipeline
let text = "comfortable running shoes"
let documentVector = text.tokenize()           // Step 1: Words
    .embed(using: embeddings)                  // Step 2: Vectors
    .averaged()                                // Step 3: Document vector
```

## Tokenization

Break text into words for embedding lookup. Tokenization converts raw text into an array of lowercase words, filtering out punctuation and whitespace.

```swift
let text = "Lightweight Running Shoes"
let words = text.tokenize()
// ["lightweight", "running", "shoes"]
```

The `.tokenize()` method:
- Converts text to lowercase for case-insensitive matching
- Splits on whitespace and newlines
- Filters empty strings
- Returns an array of clean word tokens

### Practical examples

**Basic tokenization:**
```swift
"Hello World".tokenize()
// ["hello", "world"]

"Multi-word   spacing   test".tokenize()
// ["multi-word", "spacing", "test"]

"Line1\nLine2\nLine3".tokenize()
// ["line1", "line2", "line3"]
```

**Real-world use case:**
```swift
// Process user search query
let userQuery = searchBar.text ?? ""
let queryWords = userQuery.tokenize()

// Process product descriptions
let productDescriptions = products.map { $0.description.tokenize() }
```

> Note: This is basic tokenization suitable for word embeddings. Production systems may use more sophisticated tokenization (stemming, lemmatization, subword tokenization) depending on requirements.

## Word embedding lookup

Convert tokenized words to their vector representations using pre-trained embeddings. Word embeddings are dictionaries mapping words to numerical vectors that capture semantic meaning.

```swift
let embeddings: [String: [Double]] = [
    "running": [0.8, 0.7, 0.9, 0.2],
    "shoes": [0.1, 0.9, 0.2, 0.1],
    "jogging": [0.8, 0.7, 0.8, 0.2]
]

let words = ["running", "shoes"]
let vectors = words.embed(using: embeddings)
// [[0.8, 0.7, 0.9, 0.2], [0.1, 0.9, 0.2, 0.1]]
```

The `.embed(using:)` method:
- Looks up each word in the embeddings dictionary
- Returns only vectors for words found in the dictionary
- Automatically filters out unknown words
- Preserves order of found words

### Handling unknown words

Words not in the vocabulary are silently filtered:

```swift
let words = ["running", "unknown", "shoes"]
let vectors = words.embed(using: embeddings)
// Only 2 vectors returned (running and shoes)
// "unknown" automatically filtered out
```

### Loading pre-trained embeddings

Real-world applications use pre-trained embeddings like GloVe, Word2Vec, or FastText:

```swift
// Load GloVe embeddings (example from Chapter 23)
func loadGloVe(from filePath: String) throws -> [String: [Double]] {
    let content = try String(contentsOfFile: filePath)
    var embeddings: [String: [Double]] = [:]

    for line in content.components(separatedBy: .newlines) {
        let parts = line.split(separator: " ")
        guard parts.count > 1 else { continue }

        let word = String(parts[0])
        let vector = parts.dropFirst().compactMap { Double($0) }

        guard vector.count == parts.count - 1 else { continue }
        embeddings[word] = vector
    }

    return embeddings
}

// Use loaded embeddings
let gloveEmbeddings = try loadGloVe(from: "glove.6B.50d.txt")
let vectors = words.embed(using: gloveEmbeddings)
```

## Document embeddings

Combine multiple word vectors into a single document vector by averaging. This creates a numerical representation of the entire text's semantic meaning.

```swift
let vectors = [
    [0.8, 0.7, 0.9],  // "lightweight"
    [0.7, 0.3, 0.2],  // "running"
    [0.6, 0.4, 0.3]   // "shoes"
]

let documentVector = vectors.averaged()
// [0.70, 0.47, 0.47]
```

The `.averaged()` method:
- Computes element-wise mean across all vectors
- Returns `nil` if array is empty
- Returns `nil` if vectors have inconsistent dimensions
- Requires all vectors to be same length

### Complete text-to-vector example

```swift
import Quiver

let embeddings = try loadGloVe(from: "glove.6B.50d.txt")

// Convert text to document vector
func embedText(_ text: String, embeddings: [String: [Double]]) -> [Double]? {
    let words = text.tokenize()
    let vectors = words.embed(using: embeddings)
    return vectors.averaged()
}

// Use it
let doc1 = embedText("lightweight running shoes", embeddings: embeddings)
let doc2 = embedText("comfortable jogging sneakers", embeddings: embeddings)

// Now doc1 and doc2 are vectors we can compare mathematically
```

### Why averaging works

Averaging word vectors is simple but effective:
- Captures overall topic/theme of the text
- Handles variable-length documents
- Computationally efficient
- Provides strong baseline for many applications

**Limitations:**
- Loses word order ("not good" vs "good not")
- Ignores grammatical structure
- All words weighted equally

More sophisticated approaches (weighted averaging, transformers) preserve these nuances, but simple averaging provides excellent results for semantic similarity tasks.

## Practical applications

### Semantic search

```swift
// Index documents
let products = [
    "lightweight cushioned running shoes for marathons",
    "durable trail running sneakers with grip",
    "comfortable athletic footwear for jogging"
]

let database = products.compactMap {
    embedText($0, embeddings: embeddings)
}

// Search
let query = "best running shoes for training"
let queryVector = embedText(query, embeddings: embeddings)!

// Find similar documents (see Similarity-Operations and Ranking-Operations)
let similarities = database.cosineSimilarities(to: queryVector)
let topResults = similarities.topIndices(k: 3)
```

### Document similarity

```swift
let doc1 = embedText("machine learning algorithms", embeddings: embeddings)!
let doc2 = embedText("artificial intelligence systems", embeddings: embeddings)!
let doc3 = embedText("cooking recipes", embeddings: embeddings)!

let similarity1 = doc1.cosineOfAngle(with: doc2)  // High (~0.8)
let similarity2 = doc1.cosineOfAngle(with: doc3)  // Low (~0.1)
```

### Recommendation systems

```swift
// User's liked articles
let likedArticles = [
    "deep learning neural networks",
    "computer vision applications",
    "natural language processing"
].compactMap { embedText($0, embeddings: embeddings) }

guard let userProfile = likedArticles.averaged() else {
    fatalError("Unable to create user profile from liked articles")
}

// Candidate articles
let candidates = newArticles.compactMap { article -> (Article, [Double])? in
    guard let vector = embedText(article.text, embeddings: embeddings) else {
        return nil
    }
    return (article, vector)
}

// Rank by similarity to user profile
let recommendations = candidates
    .map { (article, vector) in
        (article, vector.cosineOfAngle(with: userProfile))
    }
    .sorted { $0.1 > $1.1 }
    .prefix(10)
```

## For Python developers

Quiver's text processing matches scikit-learn and NLTK workflows:

**Python (scikit-learn):**
```python
from sklearn.feature_extraction.text import TfidfVectorizer

vectorizer = TfidfVectorizer()
vectors = vectorizer.fit_transform(documents)
```

**Swift (Quiver):**
```swift
let vectors = documents.map {
    $0.tokenize().embed(using: embeddings).averaged()
}
```

**Python (NLTK + NumPy):**
```python
import nltk
import numpy as np

tokens = nltk.word_tokenize(text.lower())
vectors = [embeddings[w] for w in tokens if w in embeddings]
doc_vector = np.mean(vectors, axis=0)
```

**Swift (Quiver):**
```swift
let docVector = text.tokenize()
    .embed(using: embeddings)
    .averaged()
```

## For iOS developers

### Integration with CoreML

```swift
import CoreML
import Quiver

// Convert CoreML text features to Quiver vectors
func processMLFeatures(_ features: MLFeatureProvider,
                       embeddings: [String: [Double]]) -> [Double]? {
    let text = features.featureValue(for: "text")!.stringValue
    return text.tokenize()
        .embed(using: embeddings)
        .averaged()
}

// Use in recommendation engine
let userQuery = textField.text ?? ""
let queryVector = userQuery.tokenize()
    .embed(using: appEmbeddings)
    .averaged()

let results = searchIndex
    .cosineSimilarities(to: queryVector!)
    .topIndices(k: 10)
```

### SwiftUI Search Integration

```swift
struct SearchView: View {
    @State private var searchText = ""
    let embeddings: [String: [Double]]
    let database: [[Double]]

    var searchResults: [Int] {
        guard let query = searchText.tokenize()
            .embed(using: embeddings)
            .averaged() else { return [] }

        return database.cosineSimilarities(to: query)
            .topIndices(k: 5)
            .map { $0.index }
    }

    var body: some View {
        List(searchResults, id: \.self) { index in
            ResultRow(item: items[index])
        }
        .searchable(text: $searchText)
    }
}
```

## Performance considerations

### Memory efficiency

Pre-trained embeddings can be large (GloVe 50d: ~171 MB for 400K words):

```swift
// Load only needed words
func loadSubsetEmbeddings(words: Set<String>,
                         from path: String) throws -> [String: [Double]] {
    var embeddings: [String: [Double]] = [:]
    let content = try String(contentsOfFile: path)

    for line in content.components(separatedBy: .newlines) {
        let parts = line.split(separator: " ")
        guard parts.count > 1 else { continue }

        let word = String(parts[0])
        guard words.contains(word) else { continue }  // Skip unwanted words

        let vector = parts.dropFirst().compactMap { Double($0) }
        embeddings[word] = vector
    }

    return embeddings
}
```

### Caching document vectors

For static content, compute document vectors once:

```swift
struct Document {
    let id: String
    let text: String
    let vector: [Double]  // Pre-computed
}

// Compute vectors once during indexing
let documents = rawTexts.compactMap { text -> Document? in
    guard let vector = embedText(text, embeddings: embeddings) else { return nil }
    return Document(id: UUID().uuidString, text: text, vector: vector)
}

// Fast search (no re-computation)
let results = documents.map { $0.vector }
    .cosineSimilarities(to: queryVector)
```

## See also

- <doc:Similarity-Operations>
- <doc:Ranking-Operations>
- <doc:Operations>
- <doc:Matrices-Operations>

## Topics

### String processing
- ``Swift/String/tokenize()``

### Word embeddings
- ``Swift/Array/embed(using:)-string-array``

### Document embeddings
- ``Swift/Array/averaged()-double-array``
- ``Swift/Array/areValidVectorDimensions()``
