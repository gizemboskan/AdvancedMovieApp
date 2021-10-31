//
//  PersonCastResults.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 31.10.2021.
//

import Foundation

// MARK: - PersonCastResults
struct PersonCastResults: Decodable {
    let cast, crew: [Movie]
    let id: Int
}
