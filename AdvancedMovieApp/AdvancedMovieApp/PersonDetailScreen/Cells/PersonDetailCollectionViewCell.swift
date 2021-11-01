//
//  PersonDetailCollectionViewCell.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 31.10.2021.
//

import UIKit

final class PersonDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Top View
    private lazy var movieImageView: UIImageView = {
        let movieImageView = UIImageView.create(image: UIImage(named: "movie"))
        movieImageView.contentMode = .scaleAspectFit
        movieImageView.sizeAnchor(width: 120, height: 120)
        movieImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        movieImageView.layer.borderWidth = 2
        movieImageView.layer.cornerRadius = 6
        movieImageView.roundCorners(with: 10, borderColor: .darkGray, borderWidth: 1.0)
        return movieImageView
    }()
    
   
    private lazy var movieNameLabel: UILabel = {
        let movieNameLabel = UILabel.create(numberOfLines: 2, font: .systemFont(ofSize: 14.0, weight: .semibold), textColor: .darkGray, textAlignment: .center)
        movieNameLabel.sizeAnchor(height: 25)
        return movieNameLabel
    }()
   
    private lazy var releaseDateLabel: UILabel = {
        let releaseDateLabel = UILabel.create(numberOfLines: 2,
                                              font: .systemFont(ofSize: 12.0,
                                                                weight: .semibold),
                                              textColor: .darkGray, textAlignment: .center)
        releaseDateLabel.sizeAnchor(height: 25)
        return releaseDateLabel
    }()
    
    // MARK: - All View
    private lazy var allStackView: UIStackView = .create(arrangedSubViews: [movieImageView, movieNameLabel, releaseDateLabel], distribution: .equalSpacing, spacing: 4)
    
    // MARK: - Initialization
    override private init(frame: CGRect) {
        super.init(frame: frame)
        arrangeViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Arrange Views
private extension PersonDetailCollectionViewCell {
    func arrangeViews() {
        backgroundColor = .white
        roundCorners(with: 12.0, borderColor: .darkGray, borderWidth: 1.0)
        contentView.addSubviews(allStackView)
        allStackView.fillSuperview()
    }
}

// MARK: - Helpers
extension PersonDetailCollectionViewCell {
    func populateUI(movieImageViewURL: URL?, movieName: String, releaseDate: String){
        guard let movieImageViewURL = movieImageViewURL else { return }
        movieImageView.kf.setImage(with: movieImageViewURL)
        movieNameLabel.text = movieName
        releaseDateLabel.text = releaseDate
        invalidateIntrinsicContentSize()
    }
}
