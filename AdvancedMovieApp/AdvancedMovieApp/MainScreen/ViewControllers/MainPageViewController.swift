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

final class MainPageViewController: UIViewController{
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var mainScreenView = MainScreenView()
    private var viewModel = MovieViewModel()
    var currentPage: Int = 1
    
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
        loadMoreMovies()
        mainScreenView.tableView.restore()
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
        viewModel.movieDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            print(data.count)
            self.mainScreenView.tableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.filteredMoviesDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            print(data.count)
            
            if data.isEmpty {
                self.mainScreenView.tableView.setEmptyView(title: "Oops! Your search was not found.",
                                                           message: "Search for another result!")
            } else {
                self.mainScreenView.tableView.restore()
            }
            self.mainScreenView.tableView.reloadData()
        }).disposed(by: bag)
        
        mainScreenView.searchBar.rx.text.orEmpty
            .changed
            .asObservable()
            .distinctUntilChanged()
            .bind(to: viewModel.searchedKeyword)
            .disposed(by: bag)
        
        mainScreenView.searchBar.rx.cancelButtonClicked
            .asObservable()
            .map { return "" }
            .bind(to: viewModel.searchedKeyword)
            .disposed(by: bag)
        
        viewModel.isFiltering.subscribe(onNext: { [weak self] isFiltering in
            guard let self = self else { return }
            if !isFiltering {
                self.mainScreenView.tableView.restore()
                self.mainScreenView.tableView.reloadData()
                self.mainScreenView.searchBar.resignFirstResponder()
            }
        }).disposed(by: bag)
        
        viewModel.isLoading.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: MainPageViewController.activityIndicator.rx.isHidden)
            .disposed(by: bag)
    }
    
    func loadMoreMovies(){
        if currentPage <= 500 {
            currentPage += 1
            viewModel.getMovieList(pageNumber: currentPage)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )
                && viewModel.isLoading.value != true){
            self.viewModel.isLoading.accept(true)
            self.loadMoreMovies()
        }
    }
}

// MARK: - UITableViewDataSource
extension MainPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.datasourceSectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.isFiltering.value ? viewModel.filteredMoviesDatasource.value.count : viewModel.movieDatasource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieListTableViewCell = tableView.deque(at: indexPath)
        let movie = {
            viewModel.isFiltering.value ?   self.viewModel.filteredMoviesDatasource.value[indexPath.row] :
                self.viewModel.movieDatasource.value[indexPath.row]
        }()
        let movieTitle = movie.title ?? ""
        let posterPath = movie.posterPath
        let movieImageViewURL = URL.posterImage(posterPath: posterPath.orEmpty)
        let foregroundPosterPath = movie.backdropPath
        let foregroundPosterImageViewURL = URL.posterImage(posterPath: foregroundPosterPath.orEmpty)
        let releaseDate = movie.releaseDate.orEmpty
        let averageVote = movie.voteAverage ?? .zero
        cell.populateUI(movieImageViewURL: movieImageViewURL, foregroundPosterImageViewURL: foregroundPosterImageViewURL, movieTitle: movieTitle,
                        releaseDate: releaseDate, averageVote: averageVote)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = {
            viewModel.isFiltering.value ? self.viewModel.filteredMoviesDatasource.value[indexPath.row] :
                self.viewModel.movieDatasource.value[indexPath.row]
        }()
        presentMovieDetail(with: movie)
    }
}

// MARK: - UITableViewDelegate
extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Movie detail
private extension MainPageViewController {
    func presentMovieDetail(with model: Movie?) {
        
        guard let viewController = MovieDetailViewController() as? MovieDetailViewController else {
            assertionFailure("MovieDetailViewController not found")
            return
        }
        viewController.viewmodel.movieDetailDatasource.accept(model)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
