//
//  Person.swift
//  AdvancedMovieApp
//
//  Created by Gizem Boskan on 26.10.2021.
//

import Foundation

// MARK: - Person
struct Person: Decodable {
    let birthday, knownForDepartment: String?
    let id: Int
    let name: String?
    let alsoKnownAs: [String?]
    let gender: Int?
    let biography: String?
    let popularity: Double?
    let placeOfBirth, profilePath: String?
    let adult: Bool?
    let imdbID: String?
    
    enum CodingKeys: String, CodingKey {
        case birthday
        case knownForDepartment = "known_for_department"
        case id, name
        case alsoKnownAs = "also_known_as"
        case gender, biography, popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbID = "imdb_id"
    }
}
