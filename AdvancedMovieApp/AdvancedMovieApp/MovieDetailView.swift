//
//  MovieDetailView.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 29.10.2021.
//

import UIKit

final class MovieDetailView: UIView {
    
    // MARK: - scrollView
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    // MARK: - topView
    private lazy var posterImageView: UIImageView = {
        let posterImageView = UIImageView.create(image: UIImage(named: "movie"))
        // TODO: blur ekle!
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        posterImageView.layer.borderWidth = 2
        posterImageView.layer.cornerRadius = 3
        return posterImageView
    }()
    
    let foregroundPosterImageView: UIImageView = {
        let foregroundPoster = UIImageView.create(image: UIImage(named: "movie"))
        foregroundPoster.contentMode = .scaleToFill
        foregroundPoster.roundCorners(with: 20, borderColor: .lightGray, borderWidth: 1.0)
        return foregroundPoster
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.sizeAnchor(height: 300)
        view.addSubviews(foregroundPosterImageView, posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        posterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        foregroundPosterImageView.translatesAutoresizingMaskIntoConstraints = false
        foregroundPosterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        foregroundPosterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    // MARK: - midView
    private lazy var movieTitleLabel: UILabel = {
        let movieTitleLabel = UILabel.create(font: .systemFont(ofSize: 16.0, weight: .semibold), textAlignment: .left)
        movieTitleLabel.text = "movie name"
        movieTitleLabel.sizeToFit()
        movieTitleLabel.lineBreakMode = .byTruncatingTail
        return movieTitleLabel
    }()
    
    private lazy var releaseDateLabel: UILabel = .create(text: "releaseDateLabel", font: .systemFont(ofSize: 12.0))
    private lazy var ratingLabel: UILabel = .create(text: "ratingLabel", font: .systemFont(ofSize: 12.0))
    private lazy var midView: UIView = {
        let view = UIView()
        let midStackView: UIStackView = .create(arrangedSubViews: [movieTitleLabel, releaseDateLabel, ratingLabel],
                                                axis: .horizontal, alignment: .center,
                                                distribution: .fillProportionally, spacing: 10.0)
        view.addSubview(midStackView)
        midStackView.fillSuperview(with: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0))
        view.backgroundColor = .darkGray
        return view
    }()
    
    // MARK: - movieDescriptionView
    private lazy var movieDescriptionLabel: UILabel = {
        let movieDescriptionLabel = UILabel.create(text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?", font: .systemFont(ofSize: 12.0, weight: .light))
        movieDescriptionLabel.sizeToFit()
        movieDescriptionLabel.fillSuperview()
        return movieDescriptionLabel
    }()
    
    // MARK: - Bottom View
    lazy var castCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieDetailCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieDetailCollectionViewCell.viewIdentifier)
        return collectionView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150,
                                 height: 150)
        layout.minimumInteritemSpacing = 8.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    // MARK: - allStackView
    // TODO Question why distribution didn't work properly when I set it to fill?
    private lazy var allStackView: UIStackView = .create(arrangedSubViews: [topView, midView, .createSeparator(with: .horizontal, backgroundColor: .lightGray), movieDescriptionLabel, castCollectionView], alignment: .center, distribution: .equalSpacing)
    
    // MARK: - Initilizations
    init() {
        super.init(frame: .zero)
        arrangeViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers

private extension MovieDetailView {
    func arrangeViews() {
        backgroundColor = .darkGray
        castCollectionView.backgroundColor = .white
        setupScrollView()
        contentView.addSubview(allStackView)
        allStackView.fillSuperview()
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.widthAnchor.constraint(equalTo: allStackView.widthAnchor).isActive = true
        foregroundPosterImageView.translatesAutoresizingMaskIntoConstraints = false
        foregroundPosterImageView.widthAnchor.constraint(equalTo: topView.widthAnchor).isActive = true
        foregroundPosterImageView.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        castCollectionView.widthAnchor.constraint(equalTo: allStackView.widthAnchor).isActive = true
        castCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}
extension MovieDetailView {
    
    func populateUI(posterImageViewURL: URL?, foregroundPosterImageViewURL: URL?, movieTitle: String,
                    releaseDate: String, rating: Double, movieDescription: String){
        guard let posterImageViewURL = posterImageViewURL else { return }
        posterImageView.kf.setImage(with: posterImageViewURL)
        foregroundPosterImageView.kf.setImage(with: foregroundPosterImageViewURL)
        movieTitleLabel.text = movieTitle
        releaseDateLabel.text = releaseDate
        ratingLabel.text = "Rating:\(String(rating))"
        movieDescriptionLabel.text = movieDescription
        invalidateIntrinsicContentSize()
    }
}


