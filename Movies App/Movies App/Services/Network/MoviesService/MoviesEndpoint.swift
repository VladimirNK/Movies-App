//
//  MoviesEndpoint.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

enum MoviesEndpoint {
    case popularMovies(params: PopularMoviesParams)
    case getGenres(params: GenreParams)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"
        case .getGenres:
            return "/3/genre/movie/list"
        }
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .popularMovies(let params):
            return params.toQueryItems
        case .getGenres(let params):
            return params.toQueryItems
        }
    }
    
    var body: [String : Any]? {
        return nil
    }
}


