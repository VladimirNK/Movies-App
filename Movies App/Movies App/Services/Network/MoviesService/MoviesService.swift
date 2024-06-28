//
//  MoviesService.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

protocol MoviesService {
    func getPopularMovies(page: Int) async throws -> Movie.Response
    func getGenres() async throws -> Genre.Response
    func getMovie(id: Int) async throws -> MovieItem.Response
}

struct MoviesServiceImpl: ApiClient, MoviesService {
    
    func getPopularMovies(page: Int) async throws -> Movie.Response {
        let params = Movie.Params(page: page, language: .localeIdentifier)
        let endpoint = MoviesEndpoint.popularMovies(params: params)
        return try await sendRequest(endpoint: endpoint)
    }
    
    func getGenres() async throws -> Genre.Response {
        let region = Locale.current.languageCode ?? .empty
        let params = Genre.Params(language: region)
        let endpoint = MoviesEndpoint.getGenres(params: params)
        return try await sendRequest(endpoint: endpoint)
    }
    
    func getMovie(id: Int) async throws -> MovieItem.Response {
        let params = MovieItem.Params(language: .localeIdentifier)
        let endpoint = MoviesEndpoint.getMovie(id: id, params: params)
        return try await sendRequest(endpoint: endpoint)
    }
    
}
