//
//  UILabel+Extension.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import UIKit

// MARK: Create UILabel
public extension UILabel {
    static func create(text: String = "",
                       numberOfLines: Int = 0,
                       font: UIFont = .systemFont(ofSize: 12.0),
                       textColor: UIColor = .black,
                       textAlignment: NSTextAlignment = .left,
                       accessibilityIdentifier: String? = nil,
                       tamic: Bool = true) -> UILabel {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.text = text
        label.accessibilityIdentifier = accessibilityIdentifier
        label.translatesAutoresizingMaskIntoConstraints = tamic
        return label
    }
}
