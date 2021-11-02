//
//  MainScreenApi.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 1.11.2021.
//

import Foundation
import RxSwift

protocol MainScreenApi {
    
}

extension MainScreenApi {
    func getMovieList(pageNumber: Int) -> Observable<MovieResults> {
        guard let url = URL.getPopularMovies(page: pageNumber) else { return .empty() }
        return URLRequest.load(resource: Resource<MovieResults>(url: url))
    }
    
    func searchMovie(movie: String) -> Observable<MovieResults> {
        guard let url = URL.searchMovie(query: movie) else { return .empty() }
        return URLRequest.load(resource: Resource<MovieResults>(url: url))
    }
}
