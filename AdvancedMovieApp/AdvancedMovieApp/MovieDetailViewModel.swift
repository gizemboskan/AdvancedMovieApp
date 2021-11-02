//
//  MovieDetailViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieDetailViewModelProtocol {
    var id: Int { get set }
    var movieDetailDatasource: BehaviorRelay<Movie?> { get set }
    var movieCreditsDatasource: BehaviorRelay<[Cast?]> { get set }
    var movieVideoDatasource: BehaviorRelay<VideoResults?> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    func getMovieCredits(movieId: Int)
    func getVideos(movieId: Int)
    var navigateToDetailReady: BehaviorRelay<PersonDetailViewModel?> { get set }
    func navigateToDetail(id: Int)
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol, MovieDetailApi {
    
    // MARK: - Properties
    private var bag = DisposeBag()
    
    var id: Int = 0
    var isLoading = BehaviorRelay<Bool>(value: false)
    var movieDetailDatasource = BehaviorRelay<Movie?>(value: nil)
    var movieCreditsDatasource = BehaviorRelay<[Cast?]>(value: [nil])
    var movieVideoDatasource = BehaviorRelay<VideoResults?>(value: nil)
    var navigateToDetailReady = BehaviorRelay<PersonDetailViewModel?>(value: nil)
    
    
    func getMovieCredits(movieId: Int) {
        Observable.just((movieId))
            .do( onNext: { [isLoading] _ in
                isLoading.accept(true)
            })
            .flatMap { movieId in
                self.getMovieCredits(movieId: movieId)
            }
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieCreditsResponse in
                self?.updateMovieCreditsDatasource(with: movieCreditsResponse.cast)
            })
            .disposed(by: bag)
    }
    
    func getVideos(movieId: Int) {
        Observable.just((movieId))
            .do( onNext: { [isLoading] _ in
                isLoading.accept(true)
            })
            .flatMap { movieId in
                self.getVideos(movieId: movieId)
            }
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieVideoResponse in
                self?.updatemovieVideoDatasource(with: movieVideoResponse)
            })
            .disposed(by: bag)
    }
    
    func navigateToDetail(id: Int) {
        let personDetailViewModel = PersonDetailViewModel()
        personDetailViewModel.personIdDatasource.accept(id)
        navigateToDetailReady.accept(personDetailViewModel)
    }
}

//MARK: - Helper Methods
extension MovieDetailViewModel {
    
    private func updateMovieCreditsDatasource(with movieCredits: [Cast?]) {
        self.movieCreditsDatasource.accept(movieCredits)
    }
    
    private func updateMovieDetailDatasource(with movie: Movie) {
        self.movieDetailDatasource.accept(movie)
    }
    
    private func updatemovieVideoDatasource(with movieVideo: VideoResults?) {
        self.movieVideoDatasource.accept(movieVideo)
    }
    
}
