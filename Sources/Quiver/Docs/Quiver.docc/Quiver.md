# ``Quiver``

@Metadata {
    @PageKind(article)
    @SupportedLanguage(swift)
    @Available(iOS, introduced: "15.0")
    @Available(macOS, introduced: "12.0")
    @Available(tvOS, introduced: "15.0")
    @Available(watchOS, introduced: "8.0")
    @Available(visionOS, introduced: "1.0")
}

@Options(scope: local)

A Swift package that provides vector mathematics, numerical computing, and statistical operations.

## Overview

[Quiver](https://github.com/waynewbishop/quiver) expands the Swift ecosystem with a native, Swift-first approach to vector mathematics and numerical computing. By building directly on Swift's powerful type system and syntax, Quiver creates an intuitive bridge between traditional array operations and advanced mathematical concepts. Built as an extension on the standard `Array` type, the framework embraces Swift's emphasis on readability and expressiveness, offering mathematical operations that feel natural to iOS and macOS developers.

### Data science in Swift

As Swift continues to expand beyond app development into domains like server-side computing, machine learning, and data analysis, the need for robust mathematical tools becomes increasingly important. Quiver serves as a foundation for data science workflows in Swift, enabling operations that are fundamental to fields like computer vision, game development, machine learning, and scientific computing.

### Why Quiver

As a pure Swift library with zero external dependencies, Quiver runs on every Apple platform — iOS, macOS, watchOS, tvOS, and visionOS — as well as server-side Swift with frameworks like Vapor, Linux environments, and containerized deployments. As a lightweight framework, Quiver is ideal for teaching environments, on-device processing, and any context where minimal dependencies and platform portability matter.
 
### Learn by example

This framework is companion to [Swift Algorithms & Data Structures](https://waynewbishop.github.io/swift-algorithms/), a comprehensive guide that teaches algorithmic thinking through hands-on Swift examples. 

## Topics

### Getting started
- <doc:Installation>
- <doc:How-It-Works>
- <doc:Primer>
- <doc:Statistics-Primer>
- <doc:Determinants-Primer>

### Vectors
- <doc:Operations>
- <doc:Elements>

### Matrices
- <doc:Matrices-Operations>
- <doc:Reshape>
- <doc:Dimensions>
- <doc:Broadcast>
- <doc:Generation>
- <doc:Random>

### Transformations
- <doc:Transformation-Basics>
- <doc:Transformation-Common>
- <doc:Composition>

### Similarity and Distance
- <doc:Similarity-Operations>
- <doc:Semantic-Search>

### Statistical Operations
- <doc:Sampling>
- <doc:Charts>
- <doc:Statistics>

### Classification
- <doc:Naive-Bayes>
- <doc:Evaluation-Metrics>

### Sorting and Selection
- <doc:Selection>

### Quick Reference
- ``Swift/Array/dot(_:)``
- ``Swift/Array/magnitude``
- ``Swift/Array/cosineOfAngle(with:)``
- ``Swift/Array/transformedBy(_:)``

### Data Analysis
- ``Swift/Array/trainTestSplit(testRatio:seed:)``
- ``Swift/Array/rollingMean(window:)``
- ``Swift/Array/histogram(bins:)``
- ``Swift/Array/quartiles()``
- ``Swift/Array/correlationMatrix()``

### Text and Embeddings
- ``Swift/String/tokenize()``
- ``Swift/Array/embed(using:)``

### Supporting Types
- ``Fraction``
- ``LogDeterminant``
- ``AggregationMethod``
- ``MatrixError``
- ``ConfusionMatrix``
- ``GaussianNaiveBayes``
- ``FeatureScaler``
