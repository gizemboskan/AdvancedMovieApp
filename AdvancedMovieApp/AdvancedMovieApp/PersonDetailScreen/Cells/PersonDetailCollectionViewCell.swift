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
        movieImageView.sizeAnchor(width: 80, height: 80)
        movieImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        movieImageView.layer.borderWidth = 2
        movieImageView.layer.cornerRadius = 6
        return movieImageView
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let releaseDateLabel = UILabel.create(numberOfLines: 2,
                                              font: .systemFont(ofSize: 12.0,
                                                                weight: .semibold),
                                              textColor: .darkGray, textAlignment: .center)
        releaseDateLabel.sizeAnchor(height: 25)
        return releaseDateLabel
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let movieNameLabel = UILabel.create(numberOfLines: 2, font: .systemFont(ofSize: 10.0, weight: .semibold), textColor: .darkGray, textAlignment: .center)
        movieNameLabel.sizeAnchor(height: 25)
        return movieNameLabel
    }()
    
    // MARK: - All View
    private lazy var allStackView: UIStackView = .create(arrangedSubViews: [movieImageView, releaseDateLabel, movieNameLabel], distribution: .equalSpacing, spacing: 10)
    
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
        backgroundColor = .lightGray
        roundCorners(with: 8.0, borderColor: .darkGray, borderWidth: 1.0)
        contentView.addSubviews(allStackView)
        allStackView.fillSuperview()
    }
}

extension PersonDetailCollectionViewCell {
    func populateUI(movieImageViewURL: URL?, releaseDate: String?, movieName: String){
        guard let movieImageViewURL = movieImageViewURL else { return }
        movieImageView.kf.setImage(with: movieImageViewURL)
        releaseDateLabel.text = releaseDate.orEmpty
        movieNameLabel.text = movieName
        invalidateIntrinsicContentSize()
        
    }
}
