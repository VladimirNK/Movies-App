//
//  DetailsViewModel.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation
import Combine

final class DetailsViewModel: ViewModel<DetailsViewModel.Input, DetailsViewModel.Output> {
    
    enum Input {
        case viewDidLoad
    }
    
    enum Output {
        case failed(error: ApiError)
        case success(movie: MovieItem.ViewModel)
        case spinner(state: Bool)
    }
    
    // MARK: - Properties
    
    //private var movie: MovieItem.ViewModel?
    
    private let router: DetailsRouter
    private let moviesService: MoviesService
    private let movieId: Int
    
    // MARK: - Init
    
    init(router: DetailsRouter, moviesService: MoviesService, movieId: Int) {
        self.router = router
        self.moviesService = moviesService
        self.movieId = movieId
    }
    
    // MARK: - Transform
    
    override func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                fetchMovie()
            }
        }.store(in: &cancellables)
         
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Private methods
    
    private func fetchMovie() {
        Task { [weak self] in
            guard let self else { return }
            output.send(.spinner(state: true))
            do {
                let movieResponse = try await moviesService.getMovie(id: movieId, language: "en-US") //en-US
                let movie = MovieItem.ViewModel(response: movieResponse)
                output.send(.success(movie: movie))
            } catch let error as ApiError {
                print(error.message)
                output.send(.failed(error: error))
            }
            output.send(.spinner(state: false))
        }
    }
}
