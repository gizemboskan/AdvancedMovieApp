//
//  MovieListTableViewCell.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 28.10.2021.
//

import UIKit

final class MovieListTableViewCell: UITableViewCell {
    
    // MARK: - Top View
    private lazy var movieImage: UIImageView = {
        let movieImageView = UIImageView.create()
        movieImageView.contentMode = .scaleAspectFit
        movieImageView.sizeAnchor(width: 100, height: 100)
        return movieImageView
    }()
    private lazy var topView: UIView = {
        let view = UIView()
        let topStackView: UIStackView = .create(arrangedSubViews: [movieImage], axis: .horizontal)
        
        view.addSubview(topStackView)
        topStackView.fillSuperview(horizontalPadding: 12.0, verticalPadding: 14.0)
        return view
    }()
    
    // MARK: - Bottom View
    private lazy var movieTitleLabel: UILabel = .create(numberOfLines: 1, font: .systemFont(ofSize: 12.0, weight: .semibold))
    
    private lazy var movieReleaseDateLabel: UILabel = .create(font: .systemFont(ofSize: 12.0), textColor: .darkGray)
    
    private lazy var movieAverageVoteLabel: UILabel = .create(font: .systemFont(ofSize: 12.0), textColor: .darkGray)
    private lazy var bottomView: UIView = {
        let view = UIView()
        let bottomStackView: UIStackView = .create(arrangedSubViews: [movieTitleLabel, movieReleaseDateLabel, movieAverageVoteLabel], spacing: 4.0)
        
        view.addSubview(bottomStackView)
        bottomStackView.fillSuperview(with: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 40.0))
        return view
    }()
    
    // MARK: - All View
    private lazy var allStackView: UIStackView = .create(arrangedSubViews: [topView, .createSeparator(with: .horizontal, backgroundColor: .lightGray), bottomView])
    
    // MARK: - Initilizations

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        arrangeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieListTableViewCell {
    
    func arrangeViews() {
        
        backgroundColor = .white
        contentView.addSubview(allStackView)
        allStackView.fillSuperview()
        roundCorners(with: 8, borderColor: .lightGray, borderWidth: 2.0)
    }
}

extension MovieListTableViewCell {
    
    func populateUI(movieImageViewURL: URL?, movieTitle: String, releaseDate: String, averageVote: Double){
        
        guard let movieImageViewURL = movieImageViewURL else { return }
        movieImage.kf.setImage(with: movieImageViewURL)
        movieTitleLabel.text = movieTitle
        movieReleaseDateLabel.text = releaseDate
        movieAverageVoteLabel.text = String(averageVote)
        invalidateIntrinsicContentSize()
        
    }
}
