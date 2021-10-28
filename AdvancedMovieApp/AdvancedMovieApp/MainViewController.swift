//
//  MainViewController.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    private var viewmodel = MovieViewModel()
    // private var castListVM: CastListViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel.getMovieList(pageNumber: 2)
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
        
        
        //        guard let url = URL.getMovieCredits(id: 287) else { return }
        //        let resource = Resource<CastResults>(url: url)
        //        URLRequest.load(resource: resource)
        //            .subscribe(onNext: { [weak self] castResponse in
        //                let casts = castResponse.cast
        //                self?.castListVM = CastListViewModel(casts)
        //
        //                print(self?.castListVM.castsVM)
        //
        //            }).disposed(by: bag)
        
        
        
        
    }
    
    
    
}
