//
//  MovieItem.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 25.06.2024.
//

import Foundation

struct MovieItem {
    
    //MARK: - Response
    
    struct Response: Decodable {
        let adult: Bool?
        let backdropPath: String?
        let belongsToCollection: MovieCollection?
        let budget: Int?
        let genres: [Genre.Item]
        let homepage: String?
        let id: Int
        let imdbID: String?
        let originCountry: [String]
        let originalLanguage: String?
        let originalTitle: String?
        let overview: String
        let popularity: Double?
        let posterPath: String
        let productionCompanies: [ProductionCompany]?
        let productionCountries: [ProductionCountry]?
        let releaseDate: String
        let revenue, runtime: Int?
        let spokenLanguages: [SpokenLanguage]?
        let status: String?
        let tagline: String?
        let title: String
        let video: Bool?
        let voteAverage: Double
        let voteCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case belongsToCollection = "belongs_to_collection"
            case budget, genres, homepage, id
            case imdbID = "imdb_id"
            case originCountry = "origin_country"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case productionCompanies = "production_companies"
            case productionCountries = "production_countries"
            case releaseDate = "release_date"
            case revenue, runtime
            case spokenLanguages = "spoken_languages"
            case status, tagline, title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
    
    struct MovieCollection: Decodable {
        let id: Int?
        let name, posterPath, backdropPath: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
        }
    }
    
    struct ProductionCompany: Decodable {
        let id: Int?
        let logoPath, name, originCountry: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case logoPath = "logo_path"
            case name
            case originCountry = "origin_country"
        }
    }
    
    struct ProductionCountry: Decodable {
        let iso3166_1, name: String?
        
        enum CodingKeys: String, CodingKey {
            case iso3166_1 = "iso_3166_1"
            case name
        }
    }
    
    struct SpokenLanguage: Decodable {
        let englishName, iso639_1, name: String?
        
        enum CodingKeys: String, CodingKey {
            case englishName = "english_name"
            case iso639_1 = "iso_639_1"
            case name
        }
    }
    
    //MARK: - ViewModel
    
    struct ViewModel {
        let id: Int
        let posterPath: String
        let title: String
        let releaseDate: Date
        let originCountry: [String]
        let genres: [String]
        let overview: String
        let voteAverage: Double
        
        init(response: MovieItem.Response) {
            self.id = response.id
            self.posterPath = Constants.API.imagePath + response.posterPath
            self.title = response.title
            self.releaseDate = response.releaseDate.toDate()
            self.originCountry = response.originCountry
            self.genres = response.genres.map { $0.name }
            self.overview = response.overview
            self.voteAverage = response.voteAverage
        }
    }
    
    //MARK: - Query Items Parameters
    
    struct Params: Encodable {
        let language: String
        
        init(language: String) {
            self.language = language
        }
    }
}
