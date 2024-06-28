//
//  Video.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 28.06.2024.
//

import Foundation

struct Video {
    
    struct Response: Decodable {
        let id: Int
        let results: [Item]
    }

    struct Item: Decodable {
        let iso639_1: String?
        let iso3166_1: String?
        let name: String?
        let key: String
        let site: String
        let size: Int?
        let type: String
        let official: Bool
        let publishedAt: String?
        let id: String?

        enum CodingKeys: String, CodingKey {
            case iso639_1 = "iso_639_1"
            case iso3166_1 = "iso_3166_1"
            case name, key, site, size, type, official
            case publishedAt = "published_at"
            case id
        }
    }
    
    struct ViewModel {
        let key: String
        
        init?(response: Response) {
            guard let item = response.results.first(where: { $0.site == "YouTube" && $0.type == "Trailer" && $0.official }) else {
                return nil
            }
            self.key = item.key
        }
    }
    
    struct Params: Encodable {
        let language: String
        
        init(language: String) {
            self.language = language
        }
    }
}
