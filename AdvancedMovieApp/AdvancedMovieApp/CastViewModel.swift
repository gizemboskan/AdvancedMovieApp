//
//  CastViewModel.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct CastListViewModel {
    let castsVM: [CastViewModel]
}

extension CastListViewModel{
    init(_ casts: [Cast]) {
        castsVM = casts.compactMap(CastViewModel.init)
    }
}

extension CastListViewModel {
    
    func castAt( _ index: Int) -> CastViewModel {
        castsVM[index]
    }
}

struct CastViewModel {
    let cast: Cast
    
    init(_ cast: Cast) {
        self.cast = cast
    }
}

extension CastViewModel {
    
    var name: Observable<String> {
        Observable<String>.just(cast.name)
    }
    
    var character: Observable<String> {
        Observable<String>.just(cast.character ?? "")
    }
}
