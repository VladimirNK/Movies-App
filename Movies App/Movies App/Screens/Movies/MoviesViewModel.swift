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
        case cellDidTap(movie: Movie.ViewModel)
        case sortDidTap(completion: ((SortOption) -> Void)?)
        case sortSelected(SortOption)
        case fetchMoreMovies
        case didPullToRefresh
        case searchBar(text: String)
    }
    
    enum Output {
        case failed(error: ApiError)
        case success(movies: [Movie.ViewModel])
        case spinner(state: Bool)
        case endRefreshing
    }
    
    // MARK: - Properties
    
    var movies: [Movie.ViewModel] = []
    var currentPage: Int = 1
    var totalPages: Int = 0
    
    private var searchText: String = ""
    private var currentSortOption: SortOption = .userScore
    
    private let router: MoviesRouter
    private let moviesService: MoviesService
    
    // MARK: - Init
    
    init(router: MoviesRouter, moviesService: MoviesService) {
        self.router = router
        self.moviesService = moviesService
        super.init()
        setupValues()
    }
    
    // MARK: - Transform
    
    override func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                fetchMovies(page: currentPage)
            case .cellDidTap(let movie):
                navigateToDetails(movie: movie)
            case .sortSelected(let sortOption):
                currentSortOption = sortOption
                sortMovies(by: sortOption)
            case .fetchMoreMovies:
                currentPage += 1
                fetchMovies(page: currentPage)
            case .didPullToRefresh:
                clearCache()
                fetchMovies(page: 1)
            case .searchBar(let searchText):
                filterMovies(by: searchText)
            case .sortDidTap(let completion):
                showSortSheet(selected: currentSortOption, onSelect: completion)
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
    
    private func sortMovies(by sortOption: SortOption) {
        var sortedMovies: [Movie.ViewModel] = []
        
        switch sortOption {
        case .alphabet:
            sortedMovies = movies.sorted(by: { $0.title < $1.title })
        case .releaseDate:
            sortedMovies = movies.sorted(by: { $0.releaseDate < $1.releaseDate })
        case .userScore:
            sortedMovies = movies.sorted(by: { $0.voteAverage > $1.voteAverage })
        }
        output.send(.success(movies: sortedMovies))
    }
    
    private func clearCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    private func filterMovies(by searchText: String) {
        let filteredMovies: [Movie.ViewModel]
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        output.send(.success(movies: filteredMovies))
    }
    
    private func fetchMovies(page: Int) {
        Task { [weak self] in
            guard let self else { return }
            
            output.send(.spinner(state: true))
            
            do {
                let response = try await moviesService.getPopularMovies(page: page, language: "uk-UA") //en-US
                let moviesPage = response.results.map { Movie.ViewModel(response: $0) }
                let uniqueMovies = moviesPage.filter { newMovie in
                    !self.movies.contains(where: { $0.id == newMovie.id })
                }
                self.movies.append(contentsOf: uniqueMovies)
                self.totalPages = response.totalPages
                sortMovies(by: currentSortOption)
            } catch let error as ApiError {
                output.send(.failed(error: error))
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
    
   
    
    // MARK: - Navigation
    
    private func navigateToDetails(movie: Movie.ViewModel) {
        router.navigate(to: .details(movieId: movie.id))
    }
    
    private func showSortSheet(selected: SortOption, onSelect: ((SortOption) -> Void)?) {
        router.navigate(to: .sort(current: selected, onSelect: onSelect))
    }
}
