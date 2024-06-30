//
//  DetailsViewModel.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit
import Combine

final class DetailsViewModel: ViewModel<DetailsViewModel.Input, DetailsViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case posterDidTap(image: UIImage)
        case showTrailerDidTap
    }
    
    enum Output {
        case success(movie: MovieItem.ViewModel)
        case spinner(state: Bool)
        case didFetchTrailer(state: Bool)
    }
    
    // MARK: - Properties
    
    private let movieId: Int
    private let router: DetailsRouter
    private let moviesService: MoviesService
    private let networkStatusMonitor: NetworkStatusMonitor
    private var trailerKey: String?
    
    // MARK: - Init
    
    init(
        movieId: Int,
        router: DetailsRouter,
        moviesService: MoviesService,
        networkStatusMonitor: NetworkStatusMonitor
    ) {
        self.movieId = movieId
        self.router = router
        self.moviesService = moviesService
        self.networkStatusMonitor = networkStatusMonitor
        super.init()
        subscribeToNetworkStatus()
    }
    
    // MARK: - Transform
    
    override func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                fetchMovie()
                fetchTrailer(id: movieId)
            case .posterDidTap(let image):
                router.navigate(to: .showPoster(image))
            case .showTrailerDidTap:
                if let trailerKey {
                    router.navigate(to: .showTrailer(key: trailerKey))
                }
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
                let movieResponse = try await moviesService.getMovie(id: movieId)
                let movie = MovieItem.ViewModel(response: movieResponse)
                output.send(.success(movie: movie))
            } catch let error as ApiError {
                router.navigate(to: .showAlert(error.message))
            }
            output.send(.spinner(state: false))
        }
    }
    
    private func fetchTrailer(id: Int) {
        Task { [weak self] in
            guard let self else { return }
            output.send(.spinner(state: true))
            do {
                let response = try await moviesService.getTrailer(id: movieId)
                let trailer = Video.ViewModel(response: response)
                self.trailerKey = trailer?.key
                output.send(.didFetchTrailer(state: trailerKey != nil))
            } catch let error as ApiError {
                router.navigate(to: .showAlert(error.message))
            }
            output.send(.spinner(state: false))
        }
    }
    
    private func subscribeToNetworkStatus() {
        networkStatusMonitor.$isNetworkAvailable
            .sink { [weak self] isAvailable in
                guard let self else { return }
                if !isAvailable {
                    let message = LocalizedString.Errors.noInternet.localized
                    router.navigate(to: .showAlert(message))
                } else {
                    fetchMovie()
                }
            }
            .store(in: &cancellables)
    }
}
