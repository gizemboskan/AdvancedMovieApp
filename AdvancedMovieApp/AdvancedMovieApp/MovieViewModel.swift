//
//  MovieViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    // MARK: - Properties
    
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var movieDatasource = BehaviorRelay<[Movie]>(value: [])
    private(set) var filteredMoviesDatasource = BehaviorRelay<[Movie]>(value: [])
    private(set) var bag = DisposeBag()
    
    var id: Int = 0
    
    func updateLoading(){
        isLoading.accept(false)
    }
    
    func getMovieList(pageNumber: Int, _ completionHandler: ((Bool) -> ())? = nil) {
        
        Observable.just((id))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
        guard let url = URL.getPopularMovies(page: pageNumber) else { return }
        URLRequest.load(resource: Resource<MovieResults>(url: url))
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieResponse in
                let movies = movieResponse.results
                self?.updateMovieDatasource(with: movies)
                
                print(self?.movieDatasource.value as Any)
                
                if let handler = completionHandler {
                    handler(true)
                }
            })
            .disposed(by: bag)
    }
    
    func searchMovie(by movie: String) {
        Observable.just((id))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
        guard let url = URL.searchMovie(query: movie) else { return }
        URLRequest.load(resource: Resource<MovieResults>(url: url))
            .observe(on: MainScheduler.instance)
            .retry(3) // to try the internet connection loss
//            .catchError{ error in
//                print(error.localizedDescription)
//                return Observable.just(WeatherResult.empty)
//            }.asDriver(onErrorJustReturn: )
        
        
    }
    
}

//MARK: - Helper Methods
extension MovieViewModel {
    
    func updateMovieDatasource(with movies: [Movie]) {
        
        self.movieDatasource.accept(movies)
    }
    
    func updateFilteredMoviesDatasource(with movies: [Movie]) {
        
        self.filteredMoviesDatasource.accept(movies)
    }
    
    
    
    //    var title: Observable<String> {
    //        Observable<String>.just(movie.title)
    //    }
    //
    //    var description: Observable<String> {
    //        Observable<String>.just(movie.overview)
    //    }
    //
    //    var poster: Observable<String> {
    //        Observable<String>.just(movie.posterPath)
    //    }
    //
    //    var releaseDate: Observable<String> {
    //        Observable<String>.just(movie.releaseDate ?? "")
    //    }
    //
    //    var averageVote: Observable<Double> {
    //        Observable<Double>.just(movie.voteAverage)
    //    }
    
}
