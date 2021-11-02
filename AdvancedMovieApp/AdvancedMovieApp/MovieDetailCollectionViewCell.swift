//
//  MovieDetailCollectionViewCell.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 30.10.2021.
//

import UIKit

final class MovieDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Top View
    private lazy var castMemberImageView: UIImageView = {
        let castMemberImageView = UIImageView.create(image: UIImage(named: "profile"))
        castMemberImageView.contentMode = .scaleAspectFit
        castMemberImageView.sizeAnchor(width: 80, height: 80)
        castMemberImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        castMemberImageView.layer.borderWidth = 2
        castMemberImageView.layer.cornerRadius = 6
        castMemberImageView.roundCorners(with: 10, borderColor: .darkGray, borderWidth: 1.0)
        return castMemberImageView
    }()
    
    private lazy var castMemberCategoryFixedLabel: UILabel = .create(text: "Character:", font: .systemFont(ofSize: 12.0), textColor: .darkOrange, textAlignment: .center)
    private lazy var castMemberCategoryLabel: UILabel = {
        let categoryLabel = UILabel.create(numberOfLines: 2,
                                           font: .systemFont(ofSize: 14.0,
                                                             weight: .semibold),
                                           textColor: .darkGray, textAlignment: .center)
        categoryLabel.lineBreakMode = .byWordWrapping
        categoryLabel.sizeAnchor(height: 25)
        return categoryLabel
    }()
    private lazy var castMemberCategoryStackView: UIStackView = .create(arrangedSubViews: [castMemberCategoryFixedLabel, castMemberCategoryLabel], spacing: 2)
    
    private lazy var castMemberNameLabel: UILabel = {
        let castMemberNameLabel = UILabel.create(numberOfLines: 2, font: .systemFont(ofSize: 12.0, weight: .semibold),
                                                 textColor: .darkGray, textAlignment: .center)
        castMemberNameLabel.sizeAnchor(height: 25)
        return castMemberNameLabel
    }()
    
    // MARK: - All View
    private lazy var allStackView: UIStackView = .create(arrangedSubViews: [castMemberImageView,
                                                                            castMemberCategoryStackView,
                                                                            castMemberNameLabel],
                                                         distribution: .equalSpacing, spacing: 4)
    
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
private extension MovieDetailCollectionViewCell {
    func arrangeViews() {
        backgroundColor = .white
        roundCorners(with: 12.0, borderColor: .darkGray, borderWidth: 1.0)
        contentView.addSubviews(allStackView)
        allStackView.fillSuperview()
    }
}

// MARK: - Helpers
extension MovieDetailCollectionViewCell {
    func populateUI(castMemberImageViewURL: URL?, castMemberCategory: String, castMemberName: String){
        
        if let castMemberImageViewURL = castMemberImageViewURL {
            castMemberImageView.kf.setImage(with: castMemberImageViewURL)
        } else {
            castMemberImageView.image = UIImage(named: "person")
        }
        castMemberCategoryLabel.text = castMemberCategory
        castMemberNameLabel.text = castMemberName
        invalidateIntrinsicContentSize()
    }
}
