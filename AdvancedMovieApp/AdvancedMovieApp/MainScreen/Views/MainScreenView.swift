//
//  MainScreenView.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import Foundation
import UIKit

final class MainScreenView: UIView {
    
    // MARK: - topView
    private lazy var searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(searchBar)
        searchBar.fillSuperview()
        return view
    }()
    
    private(set) lazy var searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.sizeAnchor(height: 60)
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.placeholder = "Search a movie or a person!"
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = UIColor(white: 0, alpha: 0.7).cgColor
        return searchBar
    }()
    
    // MARK: - Table View
    lazy var tableView: UITableView = {
        let tableView = UITableView.create(estimatedRowHeight: 72)
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.viewIdentifier)
        return tableView
    }()
    
    // MARK: - All View
    private lazy var stackView: UIStackView = .create(arrangedSubViews: [searchBar, tableView])
    
    // MARK: - Initilizations
    init() {
        super.init(frame: .zero)
        arrangeViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension MainScreenView {
    func arrangeViews() {
        backgroundColor = .darkGray
        addSubview(stackView)
        stackView.fillSuperview()
    }
}
