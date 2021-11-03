//
//  MovieViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieViewModelProtocol {
    var movieDatasource: BehaviorRelay<[Movie]> { get set }
    var filteredMoviesDatasource: BehaviorRelay<[Movie]> { get set }
    var searchedKeyword: BehaviorRelay<String> { get set }
    var isFiltering: BehaviorRelay<Bool> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<MovieDetailViewModel?> { get set }
    func getMovieList()
    func navigateToDetail(movie: Movie)
}

final class MovieViewModel: MovieViewModelProtocol, MainScreenApi {
    
    // MARK: - Properties
    private var currentPage: Int = 1
    private var bag = DisposeBag()
    
    var movieDatasource = BehaviorRelay<[Movie]>(value: [])
    var filteredMoviesDatasource = BehaviorRelay<[Movie]>(value: [])
    var searchedKeyword = BehaviorRelay<String>(value: "")
    var isFiltering = BehaviorRelay<Bool>(value: false)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var navigateToDetailReady = BehaviorRelay<MovieDetailViewModel?>(value: nil)
    
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
    
    //MARK: - Public Methods
    func getMovieList() {
        if isFiltering.value, currentPage > 500 {
            return
        }
        
        Observable.just((currentPage))
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(true)
                self?.currentPage += 1
            })
            .flatMap { pageNumber in
                self.getMovieList(pageNumber: pageNumber)
            }
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieResponse in
                self?.updateMovieDatasource(with: movieResponse.results)
            })
            .disposed(by: bag)
    }
    
    func navigateToDetail(movie: Movie) {
        let detailViewModel = MovieDetailViewModel()
        detailViewModel.movieDetailDatasource.accept(movie)
        navigateToDetailReady.accept(detailViewModel)
    }
}

//MARK: - Helper Methods
extension MovieViewModel {
    
    private func searchMovie(by movie: String) {
        Observable.just((movie))
            .do( onNext: { [isLoading] _ in
                isLoading.accept(true)
            })
            .flatMap { movie in
                self.searchMovie(movie: movie)
            }
            .observe(on: MainScheduler.instance)
            .retry(3) // to try the internet connection loss
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieResponse in
                self?.updateFilteredMoviesDatasource(with: movieResponse.results)
            })
            .disposed(by: bag)
    }
    
    private func updateMovieDatasource(with movies: [Movie]) {
        self.movieDatasource.accept(movies)
    }
    
    private func updateFilteredMoviesDatasource(with movies: [Movie]) {
        self.filteredMoviesDatasource.accept(movies)
    }
}
