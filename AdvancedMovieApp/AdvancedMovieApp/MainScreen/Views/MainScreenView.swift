//
//  MainScreenView.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import Foundation
import UIKit

final class MainScreenView: UIView {
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView.create(estimatedRowHeight: 72)
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.viewIdentifier)
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        arrangeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func arrangeViews() {
        backgroundColor = .white
        addSubview(tableView)
        tableView.fillSuperview(horizontalPadding: 12, verticalPadding: 12)
    }
}
