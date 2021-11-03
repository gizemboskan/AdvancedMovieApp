//
//  PersonDetailViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 30.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol PersonDetailViewModelProtocol {
    var personIdDatasource: BehaviorRelay<Int?> { get set }
    var personDetailsDatasource: BehaviorRelay<Person?> { get set }
    var personMovieDatasource: BehaviorRelay<[Movie?]> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<MovieDetailViewModel?> { get set }
    func getPersonDetails(personId: Int)
    func getPersonMovieCredits(personId: Int)
    func navigateToDetail(movie: Movie)
}

final class PersonDetailViewModel: PersonDetailViewModelProtocol, PersonDetailApi {
    
    // MARK: - Properties
    private var bag = DisposeBag()
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var personIdDatasource = BehaviorRelay<Int?>(value: nil)
    var personDetailsDatasource = BehaviorRelay<Person?>(value: nil)
    var personMovieDatasource = BehaviorRelay<[Movie?]>(value: [nil])
    var navigateToDetailReady = BehaviorRelay<MovieDetailViewModel?>(value: nil)
    
    //MARK: - Public Methods
    func getPersonDetails(personId: Int) {
        Observable.just((personId))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
            .flatMap { personId in
                self.getPersonDetails(personId: personId)
            }
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] personDetailsResponse in
                self?.updatePersonDetailsDatasource(with: personDetailsResponse)
            })
            .disposed(by: bag)
    }
    
    func getPersonMovieCredits(personId: Int) {
        Observable.just((personId))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
            .flatMap { personId in
                self.getPersonMovieCredits(personId: personId)
            }
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] personMovieCreditsResponse in
                self?.updatePersonMovieDatasource(with: personMovieCreditsResponse.cast)
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
extension PersonDetailViewModel {
    func updatePersonDetailsDatasource(with personDetails: Person?) {
        self.personDetailsDatasource.accept(personDetails)
    }
    
    func updatePersonMovieDatasource(with personMovieCredits: [Movie?]) {
        self.personMovieDatasource.accept(personMovieCredits)
    }
}
