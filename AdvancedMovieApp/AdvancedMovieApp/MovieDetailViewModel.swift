//
//  MovieDetailViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieDetailViewModel {
    
    // MARK: - Properties
    var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var movieDetailDatasource = BehaviorRelay<Movie?>(value: nil)
    private(set) var movieIdDetailDatasource = BehaviorRelay<Int?>(value: nil)
    private(set) var movieCreditsDatasource = BehaviorRelay<[Cast]>(value: [])
    private(set) var movieVideoDatasource = BehaviorRelay<Video?>(value: nil)
    private(set) var bag = DisposeBag()
    var id: Int = 0
    
    init() {
        movieVideoDatasource
            .asObservable()
        
        updateLoading()
    }
    func updateLoading(){
        isLoading.accept(false)
    }
    
    func getMovieCredits(movieId: Int) {
        
        Observable.just((id))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
        guard let url = URL.getMovieCredits(id: movieId) else { return }
        URLRequest.load(resource: Resource<CastResults>(url: url))
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieCreditsResponse in
                let movieCredits = movieCreditsResponse.cast
                self?.updateMovieCreditsDatasource(with: movieCredits)
                
                print(self?.movieCreditsDatasource.value as Any)
            })
            .disposed(by: bag)
        
        Observable.just((id))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
        guard let url = URL.getVideos(id: movieId) else { return }
        URLRequest.load(resource: Resource<Video>(url: url))
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] movieVideoResponse in
                let movieVideo = movieVideoResponse
                self?.updatemovieVideoDatasource(with: movieVideo)
                print(self?.movieVideoDatasource.value as Any)
            })
            .disposed(by: bag)
    }
    
    
}

//MARK: - Helper Methods
extension MovieDetailViewModel {
    
    func updateMovieCreditsDatasource(with movieCredits: [Cast]) {
        self.movieCreditsDatasource.accept(movieCredits)
    }
    
    func updateMovieDetailDatasource(with movie: Movie) {
        self.movieDetailDatasource.accept(movie)
    }
    
    func updatemovieVideoDatasource(with movieVideo: Video?) {
        self.movieVideoDatasource.accept(movieVideo)
    }
    
}
