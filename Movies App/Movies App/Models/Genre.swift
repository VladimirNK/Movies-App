//
//  Genre.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

struct Genre {
    
    //MARK: - Response
    
    struct Response: Decodable {
        let genres: [Genre.Item]
    }
    
    //MARK: - Item
    
    struct Item: Decodable {
        let id: Int
        let name: String
    }
    
    //MARK: - Query Items Parameters
    
    struct Params: Encodable {
        let language: String
        
        init(language: String) {
            self.language = language
        }
    }
}


