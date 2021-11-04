//
//  MovieDetailViewController.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 27.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var movieDetailView = MovieDetailView()
    var viewModel: MovieDetailViewModelProtocol?
    
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
        movieDetailView.castCollectionView.reloadData()
    }
}
//  MARK: - Arrange Views
extension MovieDetailViewController {
    func arrangeViews() {
        view = movieDetailView
        movieDetailView.castCollectionView.delegate = self
        movieDetailView.castCollectionView.dataSource = self
    }
}

// MARK: - Observe Data Source
extension MovieDetailViewController {
    func observeDataSource(){
        guard let viewModel = viewModel else { return }

        viewModel.movieIdDatasource
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let id = data else { return }
                self.viewModel?.getMovieDetails(movieId: id)
            }).disposed(by: bag)

        viewModel
            .movieDetailDatasource
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let movie = data else { return }
                self.observeUI(with: movie)
                viewModel.getMovieCredits(movieId: movie.id)
                viewModel.getVideos(movieId: movie.id)
            }).disposed(by: bag)
        
        viewModel.movieCreditsDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.movieDetailView.castCollectionView.reloadData()
        }).disposed(by: bag)
        
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
        
        movieDetailView.movieTrailerButton.rx.tap
            .subscribe(onNext: { [weak self] data in
                if let movieVideoURL = viewModel.movieVideoDatasource.value?.results.first?.browserURL,
                   UIApplication.shared.canOpenURL(movieVideoURL) {
                    UIApplication.shared.open(movieVideoURL)
                }
            })
            .disposed(by: bag)
        
        viewModel.navigateToDetailReady
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] personDetailViewModel in
                let personDetailViewController = PersonDetailBuilder.make(with: personDetailViewModel)
                self?.navigationController?.pushViewController(personDetailViewController, animated: true)
            })
            .disposed(by: bag)
    }
    
    func observeUI(with movie: Movie?) {
        let view = movieDetailView
        let movieTitle = movie?.title
        title = movieTitle
        let posterPath = movie?.posterPath
        let foregroundPosterPath = movie?.backdropPath
        let posterImageViewURL = URL.posterImage(posterPath: posterPath.orEmpty)
        let foregroundPosterImageViewURL = URL.posterImage(posterPath: foregroundPosterPath.orEmpty)
        let releaseDate = movie?.releaseDate.orEmpty
        let rating = movie?.voteAverage ?? 0.0
        let movieDescription = movie?.overview ?? ""
        view.populateUI(posterImageViewURL: posterImageViewURL, foregroundPosterImageViewURL: foregroundPosterImageViewURL,
                        movieTitle: movieTitle ?? "", releaseDate: releaseDate ?? "", rating: rating,
                        movieDescription: movieDescription)
    }
}
// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.movieCreditsDatasource.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        
        let cell: MovieDetailCollectionViewCell = collectionView.dequeue(at: indexPath)
        let movieCredits = viewModel.movieCreditsDatasource.value[indexPath.item]
        let profilePath = movieCredits?.profilePath.orEmpty
        let castMemberImageViewURL = URL.posterImage(posterPath: profilePath.orEmpty)
        let castMemberCategory = movieCredits?.character.orEmpty
        let castMemberName = movieCredits?.originalName
        cell.populateUI(castMemberImageViewURL: castMemberImageViewURL, castMemberCategory:
                            castMemberCategory.orEmpty, castMemberName: castMemberName.orEmpty)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        let movieCredits = viewModel.movieCreditsDatasource.value[indexPath.item]
        viewModel.navigateToDetail(id: movieCredits?.id ?? 0)
    }
}
