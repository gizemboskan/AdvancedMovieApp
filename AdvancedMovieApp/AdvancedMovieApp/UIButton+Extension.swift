//
//  UIButton+Extension.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 2.11.2021.
//

import UIKit
public extension UIButton {
    static func create(
        type: ButtonType = .custom,
        horizontalAlignment: UIControl.ContentHorizontalAlignment = .center,
        verticalAlignment: UIControl.ContentVerticalAlignment = .center,
        numberOfLines: Int = 1,
        title: String = "",
        titleColor: UIColor = .clear,
        image: UIImage? = nil,
        backgroundImage: UIImage? = nil,
        backgroundColor: UIColor = .clear,
        font: UIFont = .boldSystemFont(ofSize: 15.0)
    ) -> UIButton {
        let button = UIButton(type: type)
        button.titleLabel?.numberOfLines = numberOfLines
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setImage(image, for: .normal)
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = font
        button.contentHorizontalAlignment = horizontalAlignment
        button.contentVerticalAlignment = verticalAlignment
        return button
    }
}
