//
//  UISearchBar+Extensions.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import Foundation

import UIKit

// MARK: - Create UISearchBar
public extension UISearchBar {
    static func create(
        autocorrectionType: UITextAutocorrectionType = .no,
        enablesReturnKeyAutomatically: Bool = true,
        returnKeyType: UIReturnKeyType = .default,
        placeholder: String = "Arama",
        barTintColor: UIColor,
        textFieldBackgroundColor: UIColor = .white
    ) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.autocorrectionType = autocorrectionType
        searchBar.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        searchBar.returnKeyType = returnKeyType
        searchBar.placeholder = placeholder
        searchBar.barTintColor = barTintColor
        searchBar.backgroundColor = barTintColor
        searchBar.backgroundImage = UIImage()
        searchBar.textField?.backgroundColor = textFieldBackgroundColor
        return searchBar
    }
    var textField: UITextField? {
        value(forKey: "searchField") as? UITextField
    }
}
