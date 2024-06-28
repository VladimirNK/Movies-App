//
//  MoviesEndpoint.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

enum MoviesEndpoint {
    case popularMovies(params: Movie.Params)
    case getGenres(params: Genre.Params)
    case getMovie(id: Int, params: MovieItem.Params)
    case getTrailer(id: Int, params: Video.Params)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"
        case .getGenres:
            return "/3/genre/movie/list"
        case .getMovie(let id, _):
            return "/3/movie/\(id)"
        case .getTrailer(let id, _):
            return "/3/movie/\(id)/videos"
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
        case .getMovie(_, params: let params):
            return params.toQueryItems
        case .getTrailer(_, params: let params):
            return params.toQueryItems
        }
    }
    
    var body: [String : Any]? {
        return nil
    }
}


