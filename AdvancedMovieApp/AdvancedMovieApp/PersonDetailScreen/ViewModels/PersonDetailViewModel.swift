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
    var id: Int { get set }
    var personIdDatasource: BehaviorRelay<Int?> { get set }
    var personDetailsDatasource: BehaviorRelay<Person?> { get set }
    var personMovieDatasource: BehaviorRelay<[Movie?]> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<MovieDetailViewModel?> { get set }
    func getPersonDetails(personId: Int)
    func getPersonMovieCredits(personId: Int)
    func navigateToDetail(movie: Movie)
}

final class PersonDetailViewModel: PersonDetailViewModelProtocol {
    
    // MARK: - Properties
    private var bag = DisposeBag()
    
    var id: Int = 0
    var isLoading = BehaviorRelay<Bool>(value: false)
    var personIdDatasource = BehaviorRelay<Int?>(value: nil)
    var personDetailsDatasource = BehaviorRelay<Person?>(value: nil)
    var personMovieDatasource = BehaviorRelay<[Movie?]>(value: [nil])
    var navigateToDetailReady = BehaviorRelay<MovieDetailViewModel?>(value: nil)
    
    //MARK: - Public Methods
    func getPersonDetails(personId: Int) {
        Observable.just((id))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
        guard let url = URL.getPersonDetails(person_id: personId) else { return }
        URLRequest.load(resource: Resource<Person>(url: url))
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] personDetailsResponse in
                let personDetails = personDetailsResponse
                self?.updatePersonDetailsDatasource(with: personDetails)
            })
            .disposed(by: bag)
    }
    
    func getPersonMovieCredits(personId: Int) {
        Observable.just((id))
            .do(onNext: { [isLoading] _ in isLoading.accept(true) })
        guard let url = URL.getMovieCreditsForEachPerson(personId: personId) else { return }
        URLRequest.load(resource: Resource<PersonCastResults>(url: url))
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] personMovieCreditsResponse in
                let personMovieCredits = personMovieCreditsResponse.cast
                self?.updatePersonMovieDatasource(with: personMovieCredits)
                
                //  print(self?.personMovieDatasource.value as Any)
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
