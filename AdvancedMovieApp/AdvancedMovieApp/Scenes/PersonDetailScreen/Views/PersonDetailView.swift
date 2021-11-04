//
//  PersonDetailView.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 29.10.2021.
//

import UIKit

final class PersonDetailView: UIView {
    
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
        let posterImageView = UIImageView.create(image: UIImage(named: "profile"))
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        posterImageView.layer.borderWidth = 2
        posterImageView.layer.cornerRadius = 3
        posterImageView.roundCorners(with: 10, borderColor: .darkGray, borderWidth: 1.0)
        return posterImageView
    }()
    
    private lazy var foregroundPosterImageView: UIImageView = {
        let foregroundPoster = UIImageView.create(image: UIImage(named: "profile"))
        foregroundPoster.roundCorners(with: 30, borderColor: .darkGray, borderWidth: 1.0)
        foregroundPoster.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 0.9).enable()
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
    private lazy var personNameLabel: UILabel = {
        let personNameLabel = UILabel.create(font: .systemFont(ofSize: 18.0, weight: .semibold),
                                             textColor: .darkGray, textAlignment: .center)
        personNameLabel.text = "person name"
        personNameLabel.sizeToFit()
        return personNameLabel
    }()
    private lazy var nameStackView: UIStackView = .create(arrangedSubViews: [personNameLabel])
    
    private let birthdayLabel: UILabel = .create(text: "Birthday:", font: .systemFont(ofSize: 12.0),
                                                 textColor: .darkOrange, textAlignment: .center)
    private lazy var birthdayInputLabel: UILabel = .create(text: "birthdayInputLabel",
                                                           font: .systemFont(ofSize: 12.0),
                                                           textColor: .darkGray, textAlignment: .center)
    private lazy var birthdayStackView: UIStackView = .create(arrangedSubViews:
                                                                [birthdayLabel, birthdayInputLabel],
                                                              spacing: 2)
    
    private let placebirthLabel: UILabel = .create(text: "Place of Birth:", font: .systemFont(ofSize: 12.0),
                                                   textColor: .darkOrange, textAlignment: .center)
    private lazy var placebirthInputLabel: UILabel = .create(text: "placebirthInputLabel", font: .systemFont(ofSize: 12.0),
                                                             textColor: .darkGray, textAlignment: .center)
    private lazy var placebirthStackView: UIStackView = .create(arrangedSubViews: [placebirthLabel,
                                                                                   placebirthInputLabel],
                                                                spacing: 2)
    
    private lazy var midView: UIView = {
        let view = UIView()
        let midStackView: UIStackView = .create(arrangedSubViews: [nameStackView, birthdayStackView,
                                                                   placebirthStackView], axis: .horizontal,
                                                alignment: .center, distribution: .fillEqually, spacing: 4.0)
        
        view.addSubview(midStackView)
        midStackView.fillSuperview()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - biographyView
    private lazy var biographyLabel: UILabel = {
        let biographyLabel = UILabel.create(text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?", font: .systemFont(ofSize: 14.0, weight: .semibold), textColor: .white)
        biographyLabel.sizeToFit()
        biographyLabel.fillSuperview()
        return biographyLabel
    }()
    private lazy var biographyStackView: UIStackView = .create(arrangedSubViews: [biographyLabel])
    
    // MARK: - moviesCollectionViewLabel
    private lazy var moviesCollectionViewLabel: UILabel = {
        let moviesCollectionViewLabel = UILabel.create(text: "Played Movies", font: .systemFont(ofSize: 16.0,
                                                                                                weight: .bold),
                                                       textColor: .white, textAlignment: .left)
        moviesCollectionViewLabel.sizeToFit()
        moviesCollectionViewLabel.fillSuperview(with: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        return moviesCollectionViewLabel
    }()
    private lazy var moviesCollectionViewLabelStackView: UIStackView = .create(arrangedSubViews:
                                                                                [moviesCollectionViewLabel])
    
    // MARK: - moviesCollectionView
    lazy var moviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PersonDetailCollectionViewCell.self,
                                forCellWithReuseIdentifier: PersonDetailCollectionViewCell.viewIdentifier)
        return collectionView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.minimumInteritemSpacing = 8.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4.0, bottom: 0, right: 4.0)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    // MARK: - allStackView
    private lazy var allStackView: UIStackView = .create(arrangedSubViews: [topView, midView,
                                                                            .createSeparator(with: .horizontal,
                                                                                             backgroundColor: .lightGray),
                                                                            biographyStackView,
                                                                            .createSeparator(with: .horizontal,
                                                                                             backgroundColor: .white),
                                                                            moviesCollectionViewLabelStackView,
                                                                            moviesCollectionView],
                                                         distribution: .equalSpacing, spacing: 12)
    
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
private extension PersonDetailView {
    func arrangeViews() {
        backgroundColor = .darkGray
        moviesCollectionView.backgroundColor = .darkGray
        setupScrollView()
        contentView.addSubview(allStackView)
        allStackView.fillSuperview()
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.widthAnchor.constraint(equalTo: allStackView.widthAnchor).isActive = true
        foregroundPosterImageView.translatesAutoresizingMaskIntoConstraints = false
        foregroundPosterImageView.widthAnchor.constraint(equalTo: topView.widthAnchor).isActive = true
        foregroundPosterImageView.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.widthAnchor.constraint(equalTo: allStackView.widthAnchor).isActive = true
        moviesCollectionView.heightAnchor.constraint(equalToConstant: 180).isActive = true
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
extension PersonDetailView {
    func populateUI(posterImageViewURL: URL?, foregroundPosterImageViewURL: URL?, personName: String,
                    birthday: String, placebirth: String, biography: String){
        
        if let posterImageViewURL = posterImageViewURL {
            posterImageView.kf.setImage(with: posterImageViewURL)
        } else{
            posterImageView.image = UIImage(named: "person")
        }
        
        if let foregroundPosterImageViewURL = foregroundPosterImageViewURL {
            foregroundPosterImageView.kf.setImage(with: foregroundPosterImageViewURL)
        } else {
            foregroundPosterImageView.image = UIImage(named: "person")
        }
        
        personNameLabel.text = personName
        birthdayInputLabel.text = birthday
        placebirthInputLabel.text = placebirth
        biographyLabel.text = biography
        invalidateIntrinsicContentSize()
    }
}



