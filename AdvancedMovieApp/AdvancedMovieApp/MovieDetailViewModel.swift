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
    private(set) var movieCreditsDatasource = BehaviorRelay<[Cast]>(value: [])
    private(set) var bag = DisposeBag()
    var id: Int = 0

    
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
    }
}

//MARK: - Helper Methods
extension MovieDetailViewModel {
    
    func updateMovieCreditsDatasource(with movieCredits: [Cast]) {
        
        self.movieCreditsDatasource.accept(movieCredits)
    }
    
    
    // TODO: ADD VIDEO AND CAST MEMBERS!!
    
    //    var title: Observable<String> {
    //        Observable<String>.just(movieDetail.title ?? "")
    //    }
    //
    //    var description: Observable<String> {
    //        Observable<String>.just(movieDetail.overview ?? "")
    //    }
    //
    //    var poster: Observable<String> {
    //        Observable<String>.just(movieDetail.posterPath ?? "")
    //    }
    //
    //    var averageVote: Observable<Double> {
    //        Observable<Double>.just(movieDetail.voteAverage ?? 0.0)
    //    }
}
