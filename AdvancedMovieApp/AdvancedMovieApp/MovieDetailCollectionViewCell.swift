//
//  MovieDetailCollectionViewCell.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 30.10.2021.
//

import UIKit

final class MovieDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - Top View
    private lazy var castMemberImageView: UIImageView = {
        let castMemberImageView = UIImageView.create()
        castMemberImageView.contentMode = .scaleAspectFit
        castMemberImageView.sizeAnchor(width: 40, height: 40)
        castMemberImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        castMemberImageView.layer.borderWidth = 2
        castMemberImageView.layer.cornerRadius = 6
        castMemberImageView.anchor(top: contentView.topAnchor,
                                   leading: contentView.leadingAnchor,
                                   bottom: castMemberCategoryLabel.topAnchor,
                                   trailing: contentView.trailingAnchor,
                                   padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 8.0, right: 0.0))
        return castMemberImageView
    }()
    private lazy var castMemberCategoryLabel: UILabel = {
        let categoryLabel = UILabel.create(numberOfLines: 1,
                                           font: .systemFont(ofSize: 12.0,
                                                             weight: .semibold),
                                           textColor: .darkGray,textAlignment: .center)
        categoryLabel.anchor(top: castMemberImageView.bottomAnchor,
                             leading: contentView.trailingAnchor,
                             bottom: castMemberNameLabel.topAnchor,
                             trailing: contentView.trailingAnchor,
                             padding: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 2.0, right: 8.0))
        return castMemberCategoryLabel
    }()
    
    
    private lazy var castMemberNameLabel: UILabel = {
        let castMemberNameLabel = UILabel.create(numberOfLines: 2, font: .systemFont(ofSize: 14.0, weight: .semibold), textColor: .darkGray)
        castMemberNameLabel.anchor(top: castMemberCategoryLabel.bottomAnchor,
                                   leading: contentView.trailingAnchor,
                                   bottom: contentView.bottomAnchor,
                                   trailing: contentView.trailingAnchor,
                                   padding: UIEdgeInsets(top: 2.0, left: 8.0, bottom: 8.0, right: 0.0))
        return castMemberNameLabel
    }()
    
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
        roundCorners(with: 8.0, borderColor: .darkGray, borderWidth: 1.0)
        contentView.addSubviews(castMemberImageView, castMemberCategoryLabel, castMemberNameLabel)
    }
}
extension MovieDetailCollectionViewCell {
    
    func populateUI(castMemberImageViewURL: URL?, castMemberCategory: String, castMemberName: String){
        
        guard let castMemberImageViewURL = castMemberImageViewURL else { return }
        castMemberImageView.kf.setImage(with: castMemberImageViewURL)
        castMemberCategoryLabel.text = castMemberCategory
        castMemberNameLabel.text = castMemberName
        invalidateIntrinsicContentSize()
        
    }
}
