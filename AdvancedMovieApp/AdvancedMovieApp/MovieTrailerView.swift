////
////  MovietTrailerView.swift
////  AdvancedMovieApp
////
////  Created by Gizem Boskan on 29.10.2021.
////
//
//import UIKit
//// import YoutubePlayer_in_WKWebView
//
//class MovietTrailerView: UIView {
//
//    let scroller: UIScrollView = {
//        let scroll = UIScrollView()
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//
//        return scroll
//    }()
//
//    let content: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
//
//    let aboutLabel: UILabel = {
//        let label = UILabel()
//        label.text = "About"
//        label.font = .boldSystemFont(ofSize: 20)
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        return label
//    }()
//
//    let trailerView: WKYTPlayerView = {
//        let view = WKYTPlayerView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
//
//    let overview: UILabel = {
//        let label = UILabel()
//        label.text = "overview"
//        label.textColor = .systemGray
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        createSubviews()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        createSubviews()
//    }
//
//    func createSubviews() {
//
////        backgroundColor = .white
//
//        content.addSubview(aboutLabel)
//        content.addSubview(trailerView)
//        content.addSubview(overview)
//
//        scroller.addSubview(content)
//
//        addSubview(scroller)
//
//        NSLayoutConstraint.activate([
//
//            // scroll view constraints
//            scroller.topAnchor.constraint(equalTo: topAnchor),
//            scroller.leftAnchor.constraint(equalTo: leftAnchor),
//            scroller.rightAnchor.constraint(equalTo: rightAnchor),
//            scroller.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            // content view constraints
//            content.topAnchor.constraint(equalTo: scroller.topAnchor),
//            content.leftAnchor.constraint(equalTo: scroller.leftAnchor),
//            content.rightAnchor.constraint(equalTo: scroller.rightAnchor),
//            content.bottomAnchor.constraint(equalTo: scroller.bottomAnchor),
//            content.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
//
//            // about label constraints
//            aboutLabel.topAnchor.constraint(equalTo: content.topAnchor, constant: 16),
//            aboutLabel.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 16),
//            aboutLabel.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
//
//            // trailer view constraints
//            trailerView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 20),
//            trailerView.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 16),
//            trailerView.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
//            trailerView.heightAnchor.constraint(equalToConstant: 200),
//
//            // overview constraints
//            overview.topAnchor.constraint(equalTo: trailerView.bottomAnchor, constant: 20),
//            overview.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 16),
//            overview.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
//            overview.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -20)
//
//        ])
//    }
//
//}
