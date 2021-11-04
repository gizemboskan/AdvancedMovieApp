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
    var searchMovieAndPersonDataSource: BehaviorRelay<[Int: [MultiSearch]]>{ get set }
    var searchedKeyword: BehaviorRelay<String> { get set }
    var isFiltering: BehaviorRelay<Bool> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var onError: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<MovieDetailViewModel?> { get set }
    var navigateToPersonDetailReady: BehaviorRelay<PersonDetailViewModel?> { get set }

    func getMovieList()
    func navigateToDetail(id: Int)
    func navigateToPersonDetail(id: Int)
    func getFilteredResultCount(section: Int) -> Int
    func getFilteredResultItem(indexPath: IndexPath) -> MultiSearch?
}

final class MovieViewModel: MovieViewModelProtocol, MainScreenApi {
    
    
    // MARK: - Properties
    private var currentPage: Int = 1
    private var bag = DisposeBag()
    
    var movieDatasource = BehaviorRelay<[Movie]>(value: [])
    var searchMovieAndPersonDataSource = BehaviorRelay<[Int: [MultiSearch]]>(value: [:])
    var searchedKeyword = BehaviorRelay<String>(value: "")
    var isFiltering = BehaviorRelay<Bool>(value: false)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var onError = BehaviorRelay<Bool>(value: false)
    var navigateToDetailReady = BehaviorRelay<MovieDetailViewModel?>(value: nil)
    var navigateToPersonDetailReady = BehaviorRelay<PersonDetailViewModel?>(value: nil)

    // MARK: - Initilizations
    init() {
        searchedKeyword
            .asObservable()
            .subscribe(onNext: {[weak self] searchedText in
                if searchedText.isEmpty {
                    self?.isFiltering.accept(false)
                } else {
                    self?.isFiltering.accept(true)
                    self?.searchMovieAndPerson(by: searchedText)
                }
            })
            .disposed(by: bag)
    }
    
    //MARK: - Public Methods
    func getMovieList() {
        if isFiltering.value || currentPage > 500 {
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
            .do(onError: { _ in self.onError.accept(true) })
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieResponse in
                self?.updateMovieDatasource(with: movieResponse.results)
            })
            .disposed(by: bag)
    }
    
    func navigateToDetail(id: Int) {
        let detailViewModel = MovieDetailViewModel()
        detailViewModel.movieIdDatasource.accept(id)
        navigateToDetailReady.accept(detailViewModel)
    }
    
    func navigateToPersonDetail(id: Int) {
        let personDetailViewModel = PersonDetailViewModel()
        personDetailViewModel.personIdDatasource.accept(id)
        navigateToPersonDetailReady.accept(personDetailViewModel)
    }
    
    func getFilteredResultCount(section: Int) -> Int {
        if isFiltering.value {
            return searchMovieAndPersonDataSource.value[section]?.count ?? 0
        }
        return .zero
    }
    
    func getFilteredResultItem(indexPath: IndexPath) -> MultiSearch? {
        if isFiltering.value {
            return searchMovieAndPersonDataSource.value[indexPath.section]?[indexPath.row]
        }
        return nil
    }
}

//MARK: - Helper Methods
extension MovieViewModel {

    private func searchMovieAndPerson(by searchText: String) {
        Observable.just((searchText))
            .do( onNext: { [isLoading] _ in
                isLoading.accept(true)
            })
            .flatMap { searchText in
                self.searchMovieAndPerson(searchText: searchText)
            }
            .observe(on: MainScheduler.instance)
            .retry(3) // to try the internet connection loss
            .do(onError: { _ in self.onError.accept(true) })
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieAndPersonResponse in
                let searchedMovies = movieAndPersonResponse.results.filter { $0.mediaType == .movie }
                let searchedPeople = movieAndPersonResponse.results.filter { $0.mediaType == .person }
                var searchMovieAndPerson: [Int : [MultiSearch]] = [:]
                
                if !searchedMovies.isEmpty {
                    searchMovieAndPerson[0] = searchedMovies
                }
                if !searchedPeople.isEmpty {
                    searchMovieAndPerson[1] = searchedPeople
                }
                self?.updateFilteredMovieAndPersonDataSource(with: searchMovieAndPerson)
            })
            .disposed(by: bag)
    }
    
    private func updateMovieDatasource(with movies: [Movie]) {
        self.movieDatasource.accept(movies)
    }
    
    
    private func updateFilteredMovieAndPersonDataSource(with searchedMoviesAndPeople: [Int: [MultiSearch]]){
        self.searchMovieAndPersonDataSource.accept(searchedMoviesAndPeople)
    }
}
