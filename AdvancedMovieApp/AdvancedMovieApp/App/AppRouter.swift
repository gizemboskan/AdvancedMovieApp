//
//  AppRouter.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import UIKit

final class AppRouter {
    
    func start(window: UIWindow) {
        let viewController = MainScreenBuilder.make(with: MovieViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
