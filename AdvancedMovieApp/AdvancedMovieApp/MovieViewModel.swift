//
//  MovieViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieListViewModel {
    let moviesVM: [MovieViewModel]
}

extension MovieListViewModel{
    init(_ movies: [Movie]) {
        moviesVM = movies.compactMap(MovieViewModel.init)
    }
}

extension MovieListViewModel {
    
    func movieAt( _ index: Int) -> MovieViewModel {
        moviesVM[index]
    }
    
}

struct MovieViewModel {
    let movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
    }
}

extension MovieViewModel {
    
    var title: Observable<String> {
        Observable<String>.just(movie.title)
    }
    
    var description: Observable<String> {
        Observable<String>.just(movie.overview)
    }
    
    var poster: Observable<String> {
        Observable<String>.just(movie.posterPath)
    }
    
    var releaseDate: Observable<String> {
        Observable<String>.just(movie.releaseDate ?? "")
    }
    
    var averageVote: Observable<Double> {
        Observable<Double>.just(movie.voteAverage)
    }
    
}
