//
//  SearchBar.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import UIKit
public class SearchBar: UISearchBar {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
        
        guard let textField = textField else { return }
        textField.roundCorners(with: textField.bounds.height / 2.0,
                               borderColor: .lightGray,
                               borderWidth: 1.0)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: 42.0)
    }
}

// MARK: - Arrange Views
private extension SearchBar {
    
    func arrangeViews() {
        tintColor = .darkGray
        backgroundImage = UIImage()
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .darkGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .darkGray
        if #available(iOS 13.0, *) {
            textField?.backgroundColor = .white
        } else {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        }
        setImage(UIImage(named: "icon-action-search", in: Bundle(for: Self.self), compatibleWith: nil),
                 for: .search,
                 state: .normal)
        setPositionAdjustment(UIOffset(horizontal: 16.0, vertical: 0.0), for: .search)
        setPositionAdjustment(UIOffset(horizontal: -16.0, vertical: 0.0), for: .clear)
    }
}
