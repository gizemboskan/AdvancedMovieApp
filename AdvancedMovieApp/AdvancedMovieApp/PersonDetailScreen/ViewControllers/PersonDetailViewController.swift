//
//  PersonDetailViewController.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 27.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class PersonDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var personDetailView = PersonDetailView()
    var viewmodel = PersonDetailViewModel()
    
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
        personDetailView.moviesCollectionView.reloadData()
        viewmodel.getPersonDetails(personId: viewmodel.personIdDatasource.value ?? 0)
    }
}

//  MARK: - Arrange Views
extension PersonDetailViewController {
    func arrangeViews() {
        view = personDetailView
        personDetailView.moviesCollectionView.delegate = self
        personDetailView.moviesCollectionView.dataSource = self
    }
}

// MARK: - Observe Data Source
extension PersonDetailViewController {
    func observeDataSource(){
        viewmodel.personDetailsDatasource
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let person = self.viewmodel.personDetailsDatasource.value else { return }
                self.observeUI(with: person)
                self.viewmodel.getPersonMovieCredits(personId: person.id)
            }).disposed(by: bag)
        
        viewmodel.personMovieDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            print(data.count)
            self.personDetailView.moviesCollectionView.reloadData()
        }).disposed(by: bag)
    }
    
    func observeUI(with person: Person?) {
        let view = personDetailView
        let personName = person?.name
        title = personName
        let posterPath = person?.profilePath
        let foregroundPosterPath = person?.profilePath
        let posterImageViewURL = URL.posterImage(posterPath: posterPath.orEmpty)
        let foregroundPosterImageViewURL = URL.posterImage(posterPath: foregroundPosterPath.orEmpty)
        let birthday = person?.birthday
        let placebirth = person?.placeOfBirth
        let biography = person?.biography
        view.populateUI(posterImageViewURL: posterImageViewURL, foregroundPosterImageViewURL: foregroundPosterImageViewURL,
                        personName: personName ?? "", birthday: birthday ?? "",
                        placebirth: placebirth ?? "", biography: biography ?? "")
    }
}

// MARK: - UICollectionViewDataSource
extension PersonDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("viewmodel.personMovieDatasource.value.count \(viewmodel.personMovieDatasource.value.count)")
        return viewmodel.personMovieDatasource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PersonDetailCollectionViewCell = collectionView.dequeue(at: indexPath)
        let movieCredits = self.viewmodel.personMovieDatasource.value[indexPath.item]
        let posterPath = movieCredits.posterPath.orEmpty
        let movieImageViewURL = URL.posterImage(posterPath: posterPath)
        let releaseDate = movieCredits.releaseDate.orEmpty
        let movieName = movieCredits.title ?? ""
        cell.populateUI(movieImageViewURL: movieImageViewURL, movieName: movieName, releaseDate: releaseDate)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PersonDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieCredits = self.viewmodel.personMovieDatasource.value[indexPath.item]
        presentMovieDetail(with: movieCredits)
    }
}

// MARK: - Person detail
private extension PersonDetailViewController {
    func presentMovieDetail(with model: Movie?) {
      guard let viewController = MovieDetailViewController() as? MovieDetailViewController else {
        assertionFailure("MovieDetailViewController not found")
        return
      }
      viewController.viewmodel.movieDetailDatasource.accept(model)
      navigationController?.pushViewController(viewController, animated: true)
    }
}

