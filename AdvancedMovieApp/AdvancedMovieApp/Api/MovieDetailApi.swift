//
//  MovieDetailApi.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 2.11.2021.
//

import Foundation
import RxSwift

protocol MovieDetailApi {
    
}

extension MovieDetailApi {
    func getMovieCredits(movieId: Int) -> Observable<CastResults> {
        guard let url = URL.getMovieCredits(id: movieId) else { return .empty() }
        return URLRequest.load(resource: Resource<CastResults>(url: url))
        
    }
    
    func getVideos(movieId: Int) -> Observable<VideoResults> {
        guard let url = URL.getVideos(id: movieId) else { return .empty() }
        return URLRequest.load(resource: Resource<VideoResults>(url: url))
    }
}
