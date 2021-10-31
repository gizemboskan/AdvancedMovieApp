//
//  PersonDetailViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 30.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class PersonDetailViewModel {
    
    // MARK: - Properties
    var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var personIdDatasource = BehaviorRelay<Int?>(value: nil)
    private(set) var personDetailsDatasource = BehaviorRelay<Person?>(value: nil)
    private(set) var personMovieDatasource = BehaviorRelay<[Movie]>(value: [])
    private(set) var bag = DisposeBag()
    var id: Int = 0
    
    func updateLoading(){
        isLoading.accept(false)
    }
    
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
                
                print(self?.personDetailsDatasource.value as Any)
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
                
                print(self?.personMovieDatasource.value as Any)
            })
            .disposed(by: bag)
    }
}
//MARK: - Helper Methods
extension PersonDetailViewModel {
    func updatePersonDetailsDatasource(with personDetails: Person) {
        self.personDetailsDatasource.accept(personDetails)
    }
    
    func updatePersonMovieDatasource(with personMovieCredits: [Movie]) {
        self.personMovieDatasource.accept(personMovieCredits)
    }
}
