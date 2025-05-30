# ``Quiver``

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

A Swift package that provides vector mathematics, numerical computing, and statistical operations.

## Overview

This lightweight, functional and educational framework enables developers to perform element-wise operations, vector calculations, and matrix transformations with simple, readable syntax.

Quiver expands the Swift ecosystem with a native, Swift-first approach to numerical computing and vector mathematics. By building directly on Swift's powerful type system and syntax, Quiver creates an intuitive bridge between traditional array operations and advanced mathematical concepts. Built as an extension on the standard `Array` type, The framework embraces Swift's emphasis on readability and expressiveness, offering mathematical operations that feel natural to iOS and macOS developers.

### Data Science in Swift

As Swift continues to expand beyond app development into domains like server-side computing, machine learning, and data analysis, the need for robust mathematical tools becomes increasingly important. Quiver serves as a foundation for data science workflows in Swift, enabling operations that are fundamental to fields like computer vision, game development, machine learning, and scientific computing. 

## Topics

### Getting Started
- <doc:Design>
- <doc:Primer>
- <doc:Charts>

### Core Operations
- <doc:Elements>
- <doc:Operations>
- <doc:Broadcast>
- <doc:Inspection>
- ``Swift/Array/+(_:_:)``
- ``Swift/Array/-(_:_:)``
- ``Swift/Array/*(_:_:)``
- ``Swift/Array/dot(_:)``
- ``Swift/Array/magnitude``
- ``Swift/Array/normalized``

### Data Analysis
- <doc:Statistics>
- <doc:Comparison>
- ``Swift/Array/mean()``
- ``Swift/Array/variance(ddof:)``
- ``Swift/Array/std(ddof:)``
- ``Swift/Array/isGreaterThan(_:)``
- ``Swift/Array/masked(by:)``

### Data Creation and Manipulation
- <doc:Generation>
- <doc:Shape>
- <doc:Random>
- ``Swift/Array/zeros(_:)``
- ``Swift/Array/linspace(_:_:num:)``
- ``Swift/Array/random(_:)-6ulik``
- ``Swift/Array/transformedBy(_:)``
