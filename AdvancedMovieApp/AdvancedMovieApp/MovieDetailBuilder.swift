//
//  MovieDetailBuilder.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 2.11.2021.
//

import Foundation

final class MovieDetailBuilder {
    
    static func make(with viewModel: MovieDetailViewModel) ->
    MovieDetailViewController {
        let viewController = MovieDetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
