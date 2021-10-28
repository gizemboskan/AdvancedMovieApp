//
//  MainViewController.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class MainPageViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var mainScreenView = MainScreenView()
    private var viewmodel = MovieViewModel()
    
    // MARK: - Initilizations
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeViews()
        observeDataSource()
        viewmodel.getMovieList(pageNumber: 2)
    }
}

//  MARK: - Arrange Views
extension MainPageViewController {
    
    func arrangeViews() {
        view = mainScreenView
        title = "Movies"
        mainScreenView.tableView.delegate = self
        mainScreenView.tableView.dataSource = self
    }
}

// MARK: - Observe Data Source
extension MainPageViewController {
    
    func observeDataSource(){
        viewmodel.movieDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            print(data.count)
            self.mainScreenView.tableView.reloadData()
        }).disposed(by: bag)
        
    }
}

// MARK: - UITableViewDataSource
extension MainPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.movieDatasource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieListTableViewCell = tableView.deque(at: indexPath)
        
        let movie = viewmodel.movieDatasource.value[indexPath.row]
        
        let movieTitle = movie.title
        let posterPath = movie.posterPath
        let movieImageViewURL = URL.posterImage(posterPath: posterPath)
        let releaseDate = movie.releaseDate.orEmpty
        let averageVote = movie.voteAverage
        // let movieId = movie.id
        cell.populateUI(movieImageViewURL: movieImageViewURL, movieTitle: movieTitle, releaseDate: releaseDate, averageVote: averageVote)
        return cell
    }
}


// MARK: - UITableViewDelegate
extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        UITableView.automaticDimension
    }
    
}

