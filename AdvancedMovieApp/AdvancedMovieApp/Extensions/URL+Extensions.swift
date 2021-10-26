//
//  URL+Extensions.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation

enum Endpoints {
    static let apiKey = "bee938688bbb964dbd3b2c99cb63a365"
    static let base = "https://api.themoviedb.org/3"
    static let apiKeyParam = "?api_key=\(apiKey)"
}

extension URL {
    
    static func getPopularMovies(page: Int) -> URL?{
        return URL(string: Endpoints.base + "/movie/popular" + Endpoints.apiKeyParam + "&page=\(page)")
    }
    
    static func getMovieDetails(id: Int) -> URL?{
        
        return URL(string: Endpoints.base + "/movie/\(id)" + Endpoints.apiKeyParam)
    }
    
    static func getMovieCredits(id: Int) -> URL? {
        return URL(string: Endpoints.base + "/movie/\(id)" + "credits" + Endpoints.apiKeyParam + "&language=en-US")
    }
    
    static func search(query: String) -> URL?{
        
        return URL(string: Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))")
    }
    
    static func posterImage(posterPath: String) -> URL?{
        
        return URL(string: "https://image.tmdb.org/t/p/w200/" + posterPath)
    }
    
}
