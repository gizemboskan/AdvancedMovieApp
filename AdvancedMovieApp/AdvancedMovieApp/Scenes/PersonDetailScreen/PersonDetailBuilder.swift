//
//  PersonDetailBuilder.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 2.11.2021.
//

import UIKit

final class PersonDetailBuilder {
    
    static func make(with viewModel: PersonDetailViewModel) -> PersonDetailViewController {
        let viewController = PersonDetailViewController()
        viewController.viewModel = viewModel 
        return viewController
    }
}
