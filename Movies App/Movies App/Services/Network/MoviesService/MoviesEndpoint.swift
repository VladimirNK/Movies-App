//
//  MoviesEndpoint.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

enum MoviesEndpoint {
    case popularMovies(params: PopularMoviesParams)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .popularMovies:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .popularMovies(let params):
            return params.toQueryItems
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .popularMovies:
            return nil
        }
    }
}


