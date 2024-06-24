//
//  Genre.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

struct Genre {
    
    struct Response: Decodable {
        let genres: [Genre.Item]
    }
    
    struct Item: Decodable {
        let id: Int
        let name: String
    }
}

struct GenreParams: Encodable {
    let language: String
    
    init(language: String = "en") {
        self.language = language
    }
}
