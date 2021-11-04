//
//  MovieResults.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation
// MARK: - MovieResults
struct MovieResults: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - VideoResult
struct VideoResult: Decodable {
    
    let results: [Video]
    
}
