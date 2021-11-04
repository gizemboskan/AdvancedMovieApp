//
//  MainScreenBuilder.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import UIKit

final class MainScreenBuilder {
    
    static func make(with viewModel: MovieViewModel) -> MainPageViewController {
        let viewController = MainPageViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
