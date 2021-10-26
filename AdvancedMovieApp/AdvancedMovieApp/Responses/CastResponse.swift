//
//  CastResponse.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation

// TODO: DELETE THIS FILE !

public struct CastResponse: Decodable {
    
    private enum RootCodingKeys: String, CodingKey {
        case feed
    }
    
    private enum FeedCodingKeys: String, CodingKey {
        case results
    }
    
    let results: [Cast]
    
    init(results: [Cast]) {
        self.results = results
    }
    
    public init(from decoder: Decoder) throws {
        
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let feedContainer = try rootContainer.nestedContainer(keyedBy: FeedCodingKeys.self, forKey: .feed)
        self.results = try feedContainer.decode([Cast].self, forKey: .results)
    }
}
