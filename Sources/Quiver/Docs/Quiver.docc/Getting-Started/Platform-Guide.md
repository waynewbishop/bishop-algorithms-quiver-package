# Platform Guide

@Metadata {
  @TitleHeading("Getting Started")
}

Explore what becomes possible with Quiver and Apple platforms.

## Overview

This is a starting point for developers who want to understand what's possible with Quiver before diving into the API.

### iOS — the primary deployment target

iOS is where the majority of Swift developers ship code, and where Quiver's capabilities integrate most naturally with existing app architectures. Examples include training models on a user's own data, computing similarity across local content, and classifying behaviour patterns without a network round-trip.

```swift
import Quiver

// Tokenise and embed the search query
let tokens = "Swift performance tips".tokenize()
let embedded = tokens.embed(using: noteEmbeddings)

guard let query = embedded.meanVector() else {
    return
}

// Rank all notes by similarity — fully offline
let scores  = noteVectors.cosineSimilarities(to: query)
let results = scores.topIndices(k: 5, labels: noteTitles)
```

**What iOS enables:**

- On-device semantic search over notes, emails, or documents without a server
- Personalised recommendations computed locally from user preference vectors
- Behaviour clustering to identify distinct usage patterns across app sessions
- Classification of user-generated content without sending data off-device

> Tip: See <doc:Similarity-Operations> for batch comparison patterns and <doc:Semantic-Search> for the full tokenise → embed → rank pipeline.

### watchOS — live, on-device intelligence

watchOS is the platform where Quiver's zero-dependency design matters most. During an active workout session, the watch has continuous access to heart rate, cadence, pace, and motion data — and Quiver can process that stream in real time, updating a model incrementally as each new sample arrives. There is no network round-trip, no companion app required, and no model file to bundle or keep in sync. The intelligence lives entirely on the wrist.

Consider a user on a run. As heart rate samples stream in every few seconds, Quiver can maintain a rolling window of feature vectors and re-cluster them continuously, giving the app a live picture of which intensity zone the user is currently in — one that adapts to that user's personal physiology rather than fixed generic thresholds.

```swift
import Quiver

// Rolling window of biometric samples — [heartRate, cadence, elapsedMinutes]
let samples: [[Double]] = [
    [142.0, 82.0, 1.0], [148.0, 84.0, 2.0], [155.0, 86.0, 3.0],
    [160.0, 88.0, 4.0], [158.0, 85.0, 5.0], [145.0, 80.0, 6.0]
]

// Scale features and cluster into intensity zones
let scaler = FeatureScaler.fit(features: samples)
let scaled = scaler.transform(samples)
let model  = KMeans.fit(data: scaled, k: 3, seed: 42)

// Each label is a detected zone — adapted to this user's physiology
print(model.labels)
```

**What watchOS enables:**

- Classify workout intensity zones in real time using the user's own live biometric stream — no predefined thresholds
- Detect pace or heart rate anomalies during a run by measuring distance from the current rolling centroid
- Fit a linear regression trend on elapsed heart rate data mid-workout to anticipate fatigue before it peaks
- Build a personal performance baseline that refines itself across every session, entirely on the watch

> Tip: Quiver's models are fast enough to re-fit on every incoming sensor sample. K-Means on a 20-sample window completes in milliseconds on Apple Watch hardware, making continuous in-session updates practical. Feature scaling is essential when combining heart rate (40–200 bpm) with elapsed time (minutes) — see <doc:Feature-Scaling>.

### Swift server and Vapor

Quiver runs on Linux and integrates naturally with Vapor, enabling a class of server-side Swift applications that handle the full numerical layer of an ML pipeline in Swift. Vapor handles routing and request lifecycle. Quiver handles everything that happens to the data — embedding lookup, similarity ranking, clustering, and duplicate detection — in the same Swift process.

```swift
import Vapor
import Quiver

// Stored embeddings — loaded from any persistence layer
let vectors: [[Double]] = loadStoredVectors()

// Rank by cosine similarity to the incoming query
let scores  = vectors.cosineSimilarities(to: queryVector)
let results = scores.topIndices(k: 5, labels: labels)
```

**What Swift server and Vapor enable:**

- A vector search API built entirely in Swift 
- A semantic search endpoint that tokenises queries, looks up embeddings, and ranks results
- A clustering microservice that accepts feature vectors and returns K-Means assignments on demand
- A duplicate detection pipeline that identifies near-identical content before it reaches persistent storage

> Tip: Embeddings still need to come from a model. Quiver owns everything after that: similarity search, clustering, and ranking. See <doc:Similarity-Operations> and <doc:Semantic-Search>.

### Swift Playgrounds — interactive learning

Xcode 26 introduces the `#Playground` macro — an interactive environment that works directly with SPM packages. This makes Quiver the natural first import for students and developers exploring numerical computing interactively. 

```swift
import Quiver

#Playground {
    // Generate sample data and explore it immediately
    let grades = [88.0, 92.0, 76.0, 95.0, 84.0, 91.0, 73.0, 89.0]

    grades.mean()       // 86.0
    grades.std()        // 7.31
    grades.median()     // 88.5

    // Organize data with labeled columns
    let panel = Panel([("Math", grades), ("Science", [91.0, 85.0, 79.0, 93.0, 88.0, 90.0, 82.0, 87.0])])
    panel["Math"]       // [88.0, 92.0, 76.0, 95.0, 84.0, 91.0, 73.0, 89.0]

    // Linear algebra on plain arrays
    let a = [2.0, 3.0, 4.0]
    let b = [1.0, 5.0, 2.0]
    a.dot(b)            // 25.0
}
```

**What Swift Playgrounds enables:**

- Explore Quiver's full API interactively — statistics, linear algebra, similarity, and ML models
- Complete course assignments using `#Playground` with `import Quiver`
- Test data pipelines before moving code into an app target
- Visualise computed results with Swift Charts in the same project
