import Foundation

/// Quiver: A Swift library for vector operations
///
/// Provides vector operations for Swift arrays, inspired by NumPy.
/// 
/// Basic Usage:
/// ```swift
/// let a = [1.0, 2.0, 3.0]
/// let b = [4.0, 5.0, 6.0]
/// 
/// // Vector operations
/// let dotProduct = a.dot(b)
/// let magnitude = a.magnitude
/// let normalized = a.normalized
/// 
/// // Vector arithmetic
/// let sum = a + b
/// let difference = a - b
/// let product = a * b
/// let quotient = a / b
/// 
/// // Angle calculations
/// let angle = a.angle(with: b)
/// let degrees = a.angleDegrees(with: b)
/// ```
public enum Quiver {
    /// Library version
    public static let version = "0.1.0"
}
