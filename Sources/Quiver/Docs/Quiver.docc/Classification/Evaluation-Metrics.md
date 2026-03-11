# Evaluation Metrics

Measure classifier performance with accuracy, precision, recall, and F1 score.

## Overview

A classification model is only as useful as its evaluation. Accuracy — the fraction of correct predictions — is the most intuitive metric, but it can be deeply misleading on imbalanced datasets. If 95% of samples belong to one class, a model that always predicts that class achieves 95% accuracy while providing no useful discrimination. Precision, recall, and F1 score give a more complete picture by examining how the model handles the positive class specifically.

Quiver provides these metrics as extensions on `[Int]`, where the calling array represents predicted labels and the `actual:` parameter provides the ground truth.

### The confusion matrix

Every binary classification metric derives from four counts — true positives, false positives, true negatives, and false negatives. The `ConfusionMatrix` struct captures all four and computes the derived metrics as properties:

```swift
import Quiver

let predictions = [1, 0, 1, 1, 0, 0, 1, 0]
let actual      = [1, 0, 0, 1, 0, 1, 1, 0]

let cm = predictions.confusionMatrix(actual: actual)

cm.truePositives   // 3
cm.falsePositives  // 1
cm.trueNegatives   // 3
cm.falseNegatives  // 1
cm.accuracy        // 0.75
cm.precision       // Optional(0.75)
cm.recall          // Optional(0.75)
cm.f1Score         // Optional(0.75)
```

### Type safety over silent failures

In some ML libraries, computing precision when the model predicts no positives silently returns 0.0. This hides a critical problem — the model is not making any positive predictions at all. A precision of 0.0 could mean "every positive prediction was wrong" or "no positive predictions were made," and the only way to tell the difference is manual inspection.

Quiver returns `nil` instead, surfacing the problem at the type level:

```swift
import Quiver

let predictions = [0, 0, 0, 0, 0]  // model predicts all negative
let actual      = [1, 0, 1, 0, 0]

let p = predictions.precision(actual: actual)  // nil — no positives predicted
let r = predictions.recall(actual: actual)     // Optional(0.0) — caught 0 of 2

// Swift forces you to handle the nil case
if let precision = p {
    print("Precision: \(precision)")
} else {
    print("Precision is undefined — model predicted no positives")
}
```

This design eliminates an entire class of silent bugs. When precision is `nil`, the code cannot proceed as if everything is fine — the `Optional` type requires explicit handling.

### Labeled parameters prevent argument-swap bugs

Quiver's metrics use the calling array as predictions and a labeled `actual:` parameter for ground truth. This makes argument ordering unambiguous:

```swift
import Quiver

// The predictions are always self, the ground truth is always actual:
let f1 = predictions.f1Score(actual: actual)
```

In positional APIs, swapping the two arguments silently produces wrong results with no compile-time or runtime warning. Swift's labeled parameters make this mistake structurally impossible.

### Choosing the right metric

The right metric depends on the cost of errors in the specific domain:

**Recall-first scenarios** — When missing a positive case is expensive. Malware detection, medical screening, and customer churn prediction all benefit from high recall. A false alarm (false positive) is inconvenient, but a missed detection (false negative) is dangerous or costly.

**Precision-first scenarios** — When false positives are expensive. Spam filtering, content moderation, and fraud alerts benefit from high precision. Flagging a legitimate email as spam or freezing a valid transaction has real consequences for the user.

**F1 score** — When neither error type clearly dominates, the F1 score provides a single balanced metric. It is the harmonic mean of precision and recall, which penalizes extreme imbalances more heavily than an arithmetic mean would.

## Topics

### Confusion matrix
- ``ConfusionMatrix``

### Metric functions
- ``Swift/Array/confusionMatrix(actual:positiveLabel:)``
- ``Swift/Array/accuracy(actual:positiveLabel:)``
- ``Swift/Array/precision(actual:positiveLabel:)``
- ``Swift/Array/recall(actual:positiveLabel:)``
- ``Swift/Array/f1Score(actual:positiveLabel:)``
