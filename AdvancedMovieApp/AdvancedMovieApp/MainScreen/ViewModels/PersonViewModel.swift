//
//  PersonViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 27.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct PeopleListViewModel {
    let peopleVM: [PersonViewModel]
}

extension PeopleListViewModel{
    init(_ people: [Person]) {
        peopleVM = people.compactMap(PersonViewModel.init)
    }
}

extension PeopleListViewModel {
    
    func personAt( _ index: Int) -> PersonViewModel {
        peopleVM[index]
    }
    
}

struct PersonViewModel {
    let person: Person
    
    init(_ person: Person) {
        self.person = person
    }
}

extension PersonViewModel {
    
    var name: Observable<String> {
        Observable<String>.just(person.name)
    }
    
    var biography: Observable<String> {
        Observable<String>.just(person.biography)
    }
    
    var poster: Observable<String> {
        Observable<String>.just(person.profilePath)
    }
    
    var alsoKnownAs: Observable<[String]> {
        Observable<[String]>.just(person.alsoKnownAs)
    }
    
}
