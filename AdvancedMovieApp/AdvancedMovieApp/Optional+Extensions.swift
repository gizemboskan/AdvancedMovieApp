//
//  Optional+Extensions.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import UIKit

// MARK: - EmptyValueRepresentable
protocol EmptyValueRepresentable {

    static var emptyValue: Self { get }
}

// MARK: - String+EmptyValueRepresentable
extension String: EmptyValueRepresentable {

    static var emptyValue: String { return "" }
}

// MARK: - Array+EmptyValueRepresentable
extension Array: EmptyValueRepresentable {

    static var emptyValue: [Element] { return [] }
}

// MARK: - ArraySlice+EmptyValueRepresentable
extension ArraySlice: EmptyValueRepresentable {

    static var emptyValue: ArraySlice { return [] }
}

// MARK: - Set+EmptyValueRepresentable
extension Set: EmptyValueRepresentable {

    static var emptyValue: Set<Element> { return Set() }
}

// MARK: - Dictionary+EmptyValueRepresentable
extension Dictionary: EmptyValueRepresentable {

    static var emptyValue: [Key: Value] { return [:] }
}

// MARK: - Optional+EmptyValueRepresentable
extension Optional where Wrapped: EmptyValueRepresentable {
    
    /// Returns unwrapped value if optional is not nil; returns predefined empty value otherwise.
    var orEmpty: Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return Wrapped.emptyValue
        }
    }
}
