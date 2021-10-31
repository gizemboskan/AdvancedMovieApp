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
        return castMemberImageView
    }()
    
    private lazy var castMemberCategoryLabel: UILabel = {
        let categoryLabel = UILabel.create(numberOfLines: 2,
                                           font: .systemFont(ofSize: 12.0,
                                                             weight: .semibold),
                                           textColor: .darkGray, textAlignment: .center)
        categoryLabel.sizeAnchor(height: 25)
        return categoryLabel
    }()
    
    private lazy var castMemberNameLabel: UILabel = {
        let castMemberNameLabel = UILabel.create(numberOfLines: 2, font: .systemFont(ofSize: 10.0, weight: .semibold),
                                                 textColor: .darkGray, textAlignment: .center)
        castMemberNameLabel.sizeAnchor(height: 25)
        return castMemberNameLabel
    }()
    
    // MARK: - All View
    private lazy var allStackView: UIStackView = .create(arrangedSubViews: [castMemberImageView,
                                                                            castMemberCategoryLabel,
                                                                            castMemberNameLabel],
                                                         distribution: .equalSpacing, spacing: 10)
    
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
        backgroundColor = .lightGray
        roundCorners(with: 8.0, borderColor: .darkGray, borderWidth: 1.0)
        contentView.addSubviews(allStackView)
        allStackView.fillSuperview()
    }
}

// MARK: - Helpers
extension MovieDetailCollectionViewCell {
    func populateUI(castMemberImageViewURL: URL?, castMemberCategory: String, castMemberName: String){
        guard let castMemberImageViewURL = castMemberImageViewURL else { return }
        castMemberImageView.kf.setImage(with: castMemberImageViewURL)
        castMemberCategoryLabel.text = "castMemberCategory"
        castMemberNameLabel.text = castMemberName
        invalidateIntrinsicContentSize()
    }
}
