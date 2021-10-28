//
//  UIView+Extensions.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import Foundation
import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func sizeAnchor(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func fillSuperview(with equalPadding: CGFloat) {
        let insets = UIEdgeInsets(top: equalPadding,
                                  left: equalPadding,
                                  bottom: equalPadding,
                                  right: equalPadding)
        fillSuperview(with: insets)
    }
    
    func fillSuperview(with padding: UIEdgeInsets = .zero) {
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor, leading: superview?.safeAreaLayoutGuide.leadingAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor, trailing: superview?.safeAreaLayoutGuide.trailingAnchor, padding: padding)
    }
    
    func fillSuperview(horizontalPadding: CGFloat = .zero, verticalPadding: CGFloat = .zero) {
        let insets = UIEdgeInsets(top: verticalPadding,
                                  left: horizontalPadding,
                                  bottom: verticalPadding,
                                  right: horizontalPadding)
        fillSuperview(with: insets)
    }
    
    
    enum SeparatorAxis {
        case vertical, horizontal
    }
    
    static func createSeparator(with axis: SeparatorAxis = .vertical,
                                backgroundColor: UIColor = UIColor.lightGray) -> UIView {
        let separator = UIView()
        switch axis {
        case .horizontal:
            separator.sizeAnchor(height: 1.0)
        case .vertical:
            separator.sizeAnchor(width: 1.0)
        }
        separator.backgroundColor = backgroundColor
        return separator
    }
    
    
    // MARK: - Corner
    func roundCorners(with radius: CGFloat, borderColor: UIColor = .clear, borderWidth: CGFloat = .leastNormalMagnitude) {
        layer.cornerRadius = radius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.masksToBounds = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
