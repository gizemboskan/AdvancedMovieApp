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
    var viewmodel = MovieDetailViewModel()
    
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
        viewmodel
            .movieDetailDatasource
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let movie = self.viewmodel.movieDetailDatasource.value else { return }
                self.observeUI(with: movie)
                self.viewmodel.getMovieCredits(movieId: movie.id)
            }).disposed(by: bag)
        viewmodel.movieCreditsDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            print(data.count)
            self.movieDetailView.castCollectionView.reloadData()
        }).disposed(by: bag)
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
        view.populateUI(posterImageViewURL: posterImageViewURL, foregroundPosterImageViewURL: foregroundPosterImageViewURL, movieTitle: movieTitle ?? "", releaseDate: releaseDate ?? "", rating: rating, movieDescription: movieDescription)
    }
}
// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("viewmodel.movieCreditsDatasource.value.count \(viewmodel.movieCreditsDatasource.value.count)")
        return viewmodel.movieCreditsDatasource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieDetailCollectionViewCell = collectionView.dequeue(at: indexPath)
        let movieCredits = self.viewmodel.movieCreditsDatasource.value[indexPath.item]
        let profilePath = movieCredits.profilePath.orEmpty
        let castMemberImageViewURL = URL.posterImage(posterPath: profilePath)
        let castMemberCategory = movieCredits.job.orEmpty
        let castMemberName = movieCredits.originalName
        cell.populateUI(castMemberImageViewURL: castMemberImageViewURL, castMemberCategory: castMemberCategory, castMemberName: castMemberName)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieCredits = self.viewmodel.movieCreditsDatasource.value[indexPath.item]
        presentPersonDetail(with: movieCredits.id)
    }
}

// MARK: - Person detail
private extension MovieDetailViewController {
    
    func presentPersonDetail(with id: Int?) {
        guard let viewController = PersonDetailViewController() as? PersonDetailViewController else {
            assertionFailure("PersonDetailViewController not found")
            return
        }
        viewController.viewmodel.personIdDatasource.accept(id)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
