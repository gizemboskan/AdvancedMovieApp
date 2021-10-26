//
//  CastResults.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation

// MARK: - CastResults
struct CastResults: Codable {
    let id: Int
    let cast, crew: [Cast]
}
