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
    var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var movieDatasource = BehaviorRelay<[Movie]>(value: [])
    private(set) var filteredMoviesDatasource = BehaviorRelay<[Movie]>(value: [])
    private(set) var bag = DisposeBag()
    private(set) lazy var searchedKeyword = BehaviorRelay<String>(value: "")
    private(set) lazy var isFiltering = BehaviorRelay<Bool>(value: false)
    var id: Int = 0
    var path: String = ""
    var datasourceSectionCount: Int {
        isFiltering.value ? 2 : 1
    }
    // MARK: - Initilizations
    init() {
        searchedKeyword
            .asObservable()
            .subscribe(onNext: {[weak self] searchedText in
                if searchedText.isEmpty {
                    self?.isFiltering.accept(false)
                } else {
                    self?.isFiltering.accept(true)
                    self?.searchMovie(by: searchedText)
                }
            })
            .disposed(by: bag)
    }
    //MARK: - Helper Methods
    func updateLoading(){
        isLoading.accept(false)
    }
    
    func getMovieList(pageNumber: Int) {
        if isFiltering.value {
            return
        }
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
            })
            .disposed(by: bag)
    }
    
    func downloadPosterImage(path: String,_ completionHandler: ((Bool) -> ())? = nil){
        Observable.just((path))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
        guard let url = URL.posterImage(posterPath: path) else { return }
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
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieResponse in
                let movies = movieResponse.results
                self?.updateFilteredMoviesDatasource(with: movies)
                print(self?.filteredMoviesDatasource.value as Any)
            })
            .disposed(by: bag)
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
    
    func movieAt(at index: Int) {
        let movie = movieDatasource.value[index]
        //     let viewModel = MovieDetailViewModel(movie)
        //    delegate?.navigate(to: .detail(viewModel))
    }
    
    //    func getSectionType(at section: Int) -> SectionType {
    //        if shouldShowPreviousOrder {
    //            if section == 0 {
    //                return .movie
    //            } else if section == 1 {
    //                return isLoyaltyCampaignAvailable ? .loyalty : .person
    //            } else {
    //                return .person
    //            }
    //        } else {
    //            if section == 0 {
    //                return isLoyaltyCampaignAvailable ? .loyalty : .menu
    //            } else {
    //                return .menu
    //            }
    //        }
    //    }
    
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

// MARK: - Enums
extension MovieViewModel {
    enum SectionType {
        case movie
        case person
    }
}

