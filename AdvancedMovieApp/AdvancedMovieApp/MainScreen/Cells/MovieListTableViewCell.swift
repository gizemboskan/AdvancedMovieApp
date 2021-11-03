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
        let movieImageView = UIImageView.create(image: UIImage(named: "movie"))
        movieImageView.contentMode = .scaleAspectFit
        movieImageView.sizeAnchor(width: 120, height: 200)
        movieImageView.layer.borderColor = UIColor(white: 0, alpha: 0.7).cgColor
        movieImageView.layer.borderWidth = 2
        movieImageView.layer.cornerRadius = 3
        movieImageView.roundCorners(with: 10, borderColor: .darkGray, borderWidth: 1.0)
        return movieImageView
    }()
    
    private lazy var foregroundPosterImageView: UIImageView = {
        // TODO: blur ekle!
        let foregroundPoster = UIImageView.create(image: UIImage(named: "movie"))
        foregroundPoster.sizeAnchor(width: 400, height: 200)
        foregroundPoster.roundCorners(with: 30, borderColor: .darkGray, borderWidth: 1.0)
        foregroundPoster.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 0.7).enable()
        return foregroundPoster
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.sizeAnchor(height: 200)
        foregroundPosterImageView.fillSuperview()
        view.addSubviews(foregroundPosterImageView, movieImage)
        movieImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        movieImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        foregroundPosterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        foregroundPosterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    // MARK: - Bottom View
    private lazy var releaseDateFixedLabel: UILabel = .create(text: "Release Date:", font: .systemFont(ofSize: 12.0),
                                                              textColor: .darkOrange, textAlignment: .center)
    private lazy var movieReleaseDateLabel: UILabel = .create(font: .systemFont(ofSize: 12.0), textColor: .darkGray,
                                                              textAlignment: .center)
    private lazy var dateStackView: UIStackView = .create(arrangedSubViews: [releaseDateFixedLabel, movieReleaseDateLabel])
    
    private lazy var movieTitleLabel: UILabel = {
        let movieTitleLabel = UILabel.create(font: .systemFont(ofSize: 16.0, weight: .semibold), textColor: .darkGray,
                                             textAlignment: .center)
        movieTitleLabel.text = "movie name"
        movieTitleLabel.sizeToFit()
        movieTitleLabel.lineBreakMode = .byTruncatingTail
        return movieTitleLabel
    }()
    
    private lazy var titleStackView: UIStackView = .create(arrangedSubViews: [movieTitleLabel])
    
    private lazy var averageVoteFixedLabel: UILabel = .create(text: "Rating:", font: .systemFont(ofSize: 12.0),
                                                              textColor: .darkOrange, textAlignment: .center)
    private lazy var movieAverageVoteLabel: UILabel = .create(font: .systemFont(ofSize: 12.0), textColor: .darkGray,
                                                              textAlignment: .center)
    private lazy var voteStackView: UIStackView = .create(arrangedSubViews: [averageVoteFixedLabel, movieAverageVoteLabel])
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        let bottomStackView: UIStackView = .create(arrangedSubViews: [dateStackView, titleStackView,voteStackView],
                                                   axis: .horizontal, alignment: .center, distribution: .fillEqually,
                                                   spacing: 4.0)
        view.addSubview(bottomStackView)
        bottomStackView.fillSuperview(with: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0))
        return view
    }()
    
    // MARK: - All View
    private lazy var allStackView: UIStackView = .create(arrangedSubViews: [topView, .createSeparator(with: .horizontal,
                                                                                                      backgroundColor: .darkGray),
                                                                            bottomView])
    
    // MARK: - Initilizations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        arrangeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension MovieListTableViewCell {
    func arrangeViews() {
        backgroundColor = .white
        contentView.addSubview(allStackView)
        allStackView.fillSuperview()
        roundCorners(with: 8, borderColor: .darkGray, borderWidth: 2.0)
    }
}

extension MovieListTableViewCell {
    func populateUI(movieImageViewURL: URL?, foregroundPosterImageViewURL: URL?, movieTitle: String,
                    releaseDate: String, averageVote: Double){
        
        if let movieImageViewURL = movieImageViewURL {
            movieImage.kf.setImage(with: movieImageViewURL)
        } else{
            movieImage.image = UIImage(named: "movie")
        }
        
        if let foregroundPosterImageViewURL = foregroundPosterImageViewURL {
            foregroundPosterImageView.kf.setImage(with: foregroundPosterImageViewURL)
        } else {
            foregroundPosterImageView.image = UIImage(named: "movie")
        }
        
        movieTitleLabel.text = movieTitle
        movieReleaseDateLabel.text = releaseDate
        movieAverageVoteLabel.text = String(averageVote)
        invalidateIntrinsicContentSize()
    }
}
