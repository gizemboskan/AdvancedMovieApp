//
//  PersonDetailApi.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 2.11.2021.
//

import Foundation
import RxSwift

protocol PersonDetailApi {
    
}

extension PersonDetailApi {
    func getPersonDetails(personId: Int) -> Observable<Person> {
        guard let url = URL.getPersonDetails(person_id: personId) else { return .empty() }
        return URLRequest.load(resource: Resource<Person>(url: url))
    }
    
    func getPersonMovieCredits(personId: Int) -> Observable<PersonCastResults> {
        guard let url = URL.getMovieCreditsForEachPerson(personId: personId) else { return .empty() }
        return URLRequest.load(resource: Resource<PersonCastResults>(url: url))
    }
}
