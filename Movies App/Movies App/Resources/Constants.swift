//
//  Constants.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

struct Constants {
    
    struct API {
        static let scheme: String = "https"
        static let host: String = "api.themoviedb.org"
        static let accessToken: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMTVmN2IxMWRmYzBhYjE4YWI3MjE1YjFiYWI4YjMzYyIsIm5iZiI6MTcxOTA1ODQ5My4xMjAyNDEsInN1YiI6IjY1MDVlOTgyZmEyN2Y0MDEyZDVhMzBmZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Oq1_zfOvB-sF_djjuJl5gzYPRlGJYr1sEsQMHfNYxD8"
        static let imagePath: String = "https://image.tmdb.org/t/p/w500"
    }
    
    struct Header {
        static let contentTypeKey: String = "Content-Type"
        static let contentTypeValue: String = "application/json"
        
        static let acceptKey: String = "accept"
        
        static let authorizationKey: String = "Authorization"
        static let authorizationKeyType: String = "Bearer"
    }
    
    struct MoviesScreen {
        static let movieCellHeightMultiplier: CGFloat = 0.65
        static let paginationOffset: Int = 5
    }
    
    struct VideoPlayer {
        static let playerHeight: CGFloat = 300
    }
}

