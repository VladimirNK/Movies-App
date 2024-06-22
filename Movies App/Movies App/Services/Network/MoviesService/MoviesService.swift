//
//  MoviesService.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

protocol MoviesService {
    func getPopularMovies(page: Int, language: String) async throws -> Movie.Response
}

struct MoviesServiceImpl: ApiClient, MoviesService {
    
    func getPopularMovies(page: Int, language: String) async throws -> Movie.Response {
        let params = PopularMoviesParams(page: page, language: language)
        let endpoint = MoviesEndpoint.popularMovies(params: params)
        return try await sendRequest(endpoint: endpoint)
    }
}
