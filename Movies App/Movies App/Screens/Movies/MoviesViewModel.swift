//
//  MoviesViewModel.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation
import Combine

final class MoviesViewModel: ViewModel<MoviesViewModel.Input, MoviesViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case refreshButtonDidTap
        case cellDidTap
    }
    
    enum Output {
        case fetchMoviesDidFail(error: ApiError)
        case fetchMoviesDidSucceed(movies: [Movie.ViewModel])
        case spinner(state: Bool)
    }
    
    // MARK: - Properties
    
    private let router: MoviesRouter
    private let moviesService: MoviesService
    
    // MARK: - Init
    
    init(router: MoviesRouter, moviesService: MoviesService) {
        self.router = router
        self.moviesService = moviesService
    }
    
    // MARK: - Public methods
    
    override func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad, .refreshButtonDidTap:
                self?.getMovies()
            case .cellDidTap:
                self?.navigateToDetails()
            }
        }.store(in: &cancellables)
         
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Private methods
    
    private func getMovies() {
        Task { [weak self] in
            guard let self else { return }
            
            output.send(.spinner(state: true))
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            do {
                let request = try await moviesService.getPopularMovies(page: 1, language: "uk-UA") //en-US
                let movies = request.results.map { Movie.ViewModel(response: $0) }
                output.send(.fetchMoviesDidSucceed(movies: movies))
            } catch let error as ApiError {
                output.send(.fetchMoviesDidFail(error: error))
            }
            
            output.send(.spinner(state: false))
        }
    }
    
    // MARK: - Navigation
    
    private func navigateToDetails() {
        router.navigate(to: .details)
    }
    
}
