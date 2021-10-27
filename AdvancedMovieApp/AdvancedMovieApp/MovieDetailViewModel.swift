//
//  MovieDetailViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieDetailListViewModel {
    let movieDetailsVM: [MovieDetailViewModel]
}

extension MovieDetailListViewModel{
    init(_ movieDetails: [MovieDetail]) {
        movieDetailsVM = movieDetails.compactMap(MovieDetailViewModel.init)
    }
}

extension MovieDetailListViewModel {
    
    func movieDetailsAt( _ index: Int) -> MovieDetailViewModel {
        movieDetailsVM[index]
    }
    
}

struct MovieDetailViewModel {
    let movieDetail: MovieDetail
    
    init(_ movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
    }
}

extension MovieDetailViewModel {
    
    // TODO: ADD VIDEO AND CAST MEMBERS!!
    
    var title: Observable<String> {
        Observable<String>.just(movieDetail.title ?? "")
    }
    
    var description: Observable<String> {
        Observable<String>.just(movieDetail.overview ?? "")
    }
    
    var poster: Observable<String> {
        Observable<String>.just(movieDetail.posterPath ?? "")
    }
    
    var averageVote: Observable<Double> {
        Observable<Double>.just(movieDetail.voteAverage ?? 0.0)
    }
}
