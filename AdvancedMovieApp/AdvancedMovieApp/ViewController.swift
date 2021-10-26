//
//  ViewController.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    
    private var movieListVM: MovieListViewModel!
    private var castListVM: CastListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateNews()
        
        
    }
    
    // MARK: - Helpers
    
    private func populateNews(){
        
        //        guard let url = URL.getPopularMovies(page: 2) else { return }
        //        let resource = Resource<MovieResults>(url: url)
        //
        //        URLRequest.load(resource: resource)
        //            .subscribe(onNext: { [weak self] movieResponse in
        //                let movies = movieResponse.results
        //                self?.movieListVM = MovieListViewModel(movies)
        //
        //                print(self?.movieListVM.moviesVM)
        //
        //            }).disposed(by: bag)
        
        
        guard let url = URL.getMovieCredits(id: 287) else { return }
        let resource = Resource<CastResults>(url: url)
        URLRequest.load(resource: resource)
            .subscribe(onNext: { [weak self] castResponse in
                let casts = castResponse.crew
                self?.castListVM = CastListViewModel(casts)
                
                print(self?.castListVM.castsVM)
                
            }).disposed(by: bag)
        
    }
    
    
    
}

