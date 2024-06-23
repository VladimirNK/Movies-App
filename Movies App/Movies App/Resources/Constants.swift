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
        static let accessToken: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMTVmN2IxMWRmYzBhYjE4YWI3MjE1YjFiYWI4YjMzYyIsIm5iZiI6MTcxOTA1ODQ2Mi4zOTcyMzEsInN1YiI6IjY1MDVlOTgyZmEyN2Y0MDEyZDVhMzBmZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SyxqxVLszS-sHliwvYoTftKYk-z3S2P2Q-B9JKjtfPU"
    }
    
    struct Header {
        static let contentTypeKey: String = "Content-Type"
        static let contentTypeValue: String = "application/json"
        
        static let acceptKey: String = "accept"
        
        static let authorizationKey: String = "Authorization"
        static let authorizationKeyType: String = "Bearer"
    }
}
