//
//  MoviesService.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

protocol MoviesService {
    func getPopularMovies(page: Int, language: String) async throws -> Movie.Response
    func getGenres(language: String) async throws -> Genre.Response
    func getMovie(id: Int, language: String) async throws -> MovieItem.Response
}

struct MoviesServiceImpl: ApiClient, MoviesService {
    
    func getPopularMovies(page: Int, language: String) async throws -> Movie.Response {
        let params = Movie.Params(page: page, language: language)
        let endpoint = MoviesEndpoint.popularMovies(params: params)
        return try await sendRequest(endpoint: endpoint)
    }
    
    func getGenres(language: String) async throws -> Genre.Response {
        let params = Genre.Params(language: language)
        let endpoint = MoviesEndpoint.getGenres(params: params)
        return try await sendRequest(endpoint: endpoint)
    }
    
    func getMovie(id: Int, language: String) async throws -> MovieItem.Response {
        let params = MovieItem.Params(language: language)
        let endpoint = MoviesEndpoint.getMovie(id: id, params: params)
        return try await sendRequest(endpoint: endpoint)
    }
    
}
