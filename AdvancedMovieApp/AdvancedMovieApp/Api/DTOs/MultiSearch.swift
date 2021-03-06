//
//  MultiSearch.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 3.11.2021.
//


// MARK: - Welcome
struct MultiSearchResult: Decodable {
    let page: Int
    let results: [MultiSearch]
    let totalResults, totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

// MARK: - Result
struct MultiSearch: Decodable {
    let posterPath: String?
    let popularity: Double?
    let id: Int?
    let overview: String?
    let backdropPath: String?
    let voteAverage: Double?
    let mediaType: MediaType
    let firstAirDate: String?
    let originCountry: [String]?
    let genreIDS: [Int]?
    let voteCount: Int?
    let name, originalName: String?
    let adult: Bool?
    let releaseDate, originalTitle, title: String?
    let video: Bool?
    let profilePath: String?
    let knownFor: [MultiSearch]?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity, id, overview
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIDS = "genre_ids"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case adult
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case title, video
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

enum MediaType: String, Decodable {
    case movie = "movie"
    case person = "person"
    case tv = "tv"
}
