//
//  MainViewController.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class MainPageViewController: UIViewController{
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var mainScreenView = MainScreenView()
    var viewModel: MovieViewModelProtocol?
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideKeyboardWhenTappedAround()
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
        guard let viewModel = viewModel else { return }
        
        viewModel.movieDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.mainScreenView.tableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.filteredMoviesDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            
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
        
        viewModel.navigateToDetailReady
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] detailViewModel in
                let detailViewController = MovieDetailBuilder.make(with: detailViewModel)
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: bag)
        
        viewModel.isLoading.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.startLoading()
                } else {
                    self?.stopLoading()
                }
            })
            .disposed(by: bag)
        
        viewModel.onError.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] onError in
                if onError {
                    self?.showAlertController()
                }
            })
            .disposed(by: bag)
    }
    
    func loadMoreMovies(){
        viewModel?.getMovieList()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel else { return }
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )
                && viewModel.isLoading.value != true){
            viewModel.isLoading.accept(true)
            self.loadMoreMovies()
        }
    }
}

// MARK: - UITableViewDataSource
extension MainPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return .zero }
        
        return viewModel.isFiltering.value ? viewModel.filteredMoviesDatasource.value.count : viewModel.movieDatasource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        let cell: MovieListTableViewCell = tableView.deque(at: indexPath)
        let movie = {
            viewModel.isFiltering.value ? viewModel.filteredMoviesDatasource.value[indexPath.row] :
                viewModel.movieDatasource.value[indexPath.row]
        }()
        let movieTitle = movie.title.orEmpty
        let posterPath = movie.posterPath
        let movieImageViewURL = URL.posterImage(posterPath: posterPath.orEmpty)
        let foregroundPosterPath = movie.backdropPath
        let foregroundPosterImageViewURL = URL.posterImage(posterPath: foregroundPosterPath.orEmpty)
        let releaseDate = String(movie.releaseDate?.prefix(4) ?? "")
        let averageVote = movie.voteAverage ?? .zero
        cell.populateUI(movieImageViewURL: movieImageViewURL, foregroundPosterImageViewURL: foregroundPosterImageViewURL,
                        movieTitle: movieTitle,
                        releaseDate: releaseDate, averageVote: averageVote)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        let movie = {
            viewModel.isFiltering.value ? viewModel.filteredMoviesDatasource.value[indexPath.row] :
                viewModel.movieDatasource.value[indexPath.row]
        }()
        viewModel.navigateToDetail(movie: movie)
    }
}

// MARK: - UITableViewDelegate
extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

