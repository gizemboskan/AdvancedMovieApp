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
    var viewModel: PersonDetailViewModelProtocol?
    
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
        viewModel?.getPersonDetails(personId: viewModel?.personIdDatasource.value ?? 0)
        
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
        guard let viewModel = viewModel else { return }
        
        viewModel.personDetailsDatasource
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let person = viewModel.personDetailsDatasource.value else { return }
                self.observeUI(with: person)
                viewModel.getPersonMovieCredits(personId: person.id)
            }).disposed(by: bag)
        
        viewModel.personMovieDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.personDetailView.moviesCollectionView.reloadData()
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
        
        viewModel.navigateToDetailReady
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] detailViewModel in
                let detailViewController = MovieDetailBuilder.make(with: detailViewModel)
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: bag)
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
        guard let viewModel = viewModel else { return .zero }
        
        return viewModel.personMovieDatasource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        
        let cell: PersonDetailCollectionViewCell = collectionView.dequeue(at: indexPath)
        let movieCredits = viewModel.personMovieDatasource.value[indexPath.item]
        let posterPath = movieCredits?.posterPath.orEmpty
        let movieImageViewURL = URL.posterImage(posterPath: posterPath.orEmpty)
        let releaseDate = movieCredits?.releaseDate.orEmpty
        let movieName = movieCredits?.title ?? ""
        cell.populateUI(movieImageViewURL: movieImageViewURL, movieName: movieName, releaseDate: releaseDate.orEmpty)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PersonDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        guard let movieCredits = viewModel.personMovieDatasource.value[indexPath.item] else { return  }
        viewModel.navigateToDetail(movie: movieCredits)
    }
}


