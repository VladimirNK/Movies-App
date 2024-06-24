//
//  MoviesViewModel.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation
import Combine
import SDWebImage

final class MoviesViewModel: ViewModel<MoviesViewModel.Input, MoviesViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case cellDidTap
        case selectFilterDidTap(SortOption)
        case fetchMoreMovies
        case didPullToRefresh
    }
    
    enum Output {
        case fetchMoviesDidFail(error: ApiError)
        case fetchMoviesDidSucceed
        case spinner(state: Bool)
        case filter(selected: SortOption, movies: [Movie.ViewModel])
        case endRefreshing
    }
    
    // MARK: - Properties
    
    var movies: [Movie.ViewModel] = []
    var currentPage: Int = 1
    var totalPages: Int = 0
    
    private let router: MoviesRouter
    private let moviesService: MoviesService
    
    // MARK: - Init
    
    init(router: MoviesRouter, moviesService: MoviesService) {
        self.router = router
        self.moviesService = moviesService
        super.init()
        setupValues()
    }
    
    // MARK: - Public methods
    
    override func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                fetchMovies(page: currentPage)
            case .cellDidTap:
                navigateToDetails()
            case .selectFilterDidTap(let sortOption):
                break
            case .fetchMoreMovies:
                currentPage += 1
                fetchMovies(page: currentPage)
            case .didPullToRefresh:
                clearCache()
                fetchMovies(page: 1)
            }
        }.store(in: &cancellables)
         
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Private methods
    
    private func setupValues() {
        /// Fetch movie genres if its nil for now
        if AppUserDefaults.genres == nil {
            fetchGenres()
        }
    }
    
    private func clearCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    private func fetchMovies(page: Int) {
        Task { [weak self] in
            guard let self else { return }
            
            output.send(.spinner(state: true))
            //try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            do {
                let response = try await moviesService.getPopularMovies(page: page, language: "uk-UA") //en-US
                let moviesPage = response.results.map { Movie.ViewModel(response: $0) }
                let uniqueMovies = moviesPage.filter { newMovie in
                    !self.movies.contains(where: { $0.id == newMovie.id })
                }
                self.movies.append(contentsOf: uniqueMovies)
                self.totalPages = response.totalPages
                output.send(.fetchMoviesDidSucceed)
            } catch let error as ApiError {
                output.send(.fetchMoviesDidFail(error: error))
            }
            output.send(.spinner(state: false))
            output.send(.endRefreshing)
        }
    }
    
    private func fetchGenres() {
        Task { [weak self] in
            guard let self else { return }
            output.send(.spinner(state: true))
            
            do {
                let response = try await moviesService.getGenres(language: "uk")
                let genreDict = response.genres.reduce(into: [Int: String]()) { dict, genre in
                    dict[genre.id] = genre.name
                }
                AppUserDefaults.genres = genreDict
            } catch let error as ApiError {
                print(error)
            }
            output.send(.spinner(state: false))
        }
    }
    
    private func sortMovies(by sort: SortOption, movies: [Movie.ViewModel]) {
        var sortedMovies: [Movie.ViewModel] = []
        
        switch sort {
        case .releaseDate:
            sortedMovies = movies.sorted {
                guard let date1 = $0.releaseDate, let date2 = $1.releaseDate else {
                    return false
                    // work with sorting error
                }
                return date1 > date2
            }
        case .userScore:
            sortedMovies = movies.sorted { $0.voteAverage > $1.voteAverage }
        }
        output.send(.filter(selected: sort, movies: sortedMovies))
    }
    
    // MARK: - Navigation
    
    private func navigateToDetails() {
        router.navigate(to: .details)
    }
    
    private func showSortSheet(selected: SortOption, onSelect: @escaping (SortOption) -> Void) {
        router.navigate(to: .sort(current: selected, onSelect: onSelect))
    }
}
