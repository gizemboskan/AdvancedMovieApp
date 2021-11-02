//
//  Video.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 2.11.2021.
//

import UIKit
// MARK: - Video
struct Video: Decodable {
    let id: String
    let key: String
    let name: String
    let size: Int
}
extension Video {
    
    var browserURL: URL? {
        URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    var deepLinkURL: URL? {
        URL(string: "youtube://\(key)")
    }
    
    var thumbnailURL: URL? {
        URL(string: "https://img.youtube.com/vi/\(key)/mqdefault.jpg")
    }
}
