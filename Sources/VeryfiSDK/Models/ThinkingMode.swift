//
//  ThinkingMode.swift
//  VeryfiSDK
//
import Foundation

/// Extra LLM pass on the line items of a document.
/// It only takes effect if thinking mode is enabled for your account.
public enum ThinkingMode: String {
    /// The light thinking pass.
    case light
    /// The deep thinking pass. It takes longer than `light`.
    case deep
}
