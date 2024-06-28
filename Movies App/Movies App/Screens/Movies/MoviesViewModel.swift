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
        case success(movies: [Movie.ViewModel])
        case spinner(state: Bool)
        case endRefreshing
    }
    
    // MARK: - Properties
    
    private var movies: [Movie.ViewModel] = []
    var currentPage: Int = 1
    var totalPages: Int = .zero
    
    private var searchText: String = .empty
    private var currentSortOption: SortOption = .userScore
    
    private let router: MoviesRouter
    private let moviesService: MoviesService
    private let networkStatusMonitor: NetworkStatusMonitor
    
    // MARK: - Init
    
    init(
        router: MoviesRouter,
        moviesService: MoviesService,
        networkStatusMonitor: NetworkStatusMonitor
    ) {
        self.router = router
        self.moviesService = moviesService
        self.networkStatusMonitor = networkStatusMonitor
        super.init()
        checkGenres()
        subscribeToNetworkStatus()
    }
    
    // MARK: - Transform
    
    override func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                fetchMovies(page: currentPage)
            case .cellDidTap(let movie):
                router.navigate(to: .details(movieId: movie.id))
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
                router.navigate(to: .sort(current: currentSortOption, onSelect: completion))
            }
        }.store(in: &cancellables)
         
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Private methods
    
    private func checkGenres() {
        if AppUserDefaults.genres == nil || AppUserDefaults.currentLocale != Locale.current.identifier {
            fetchGenres()
        }
    }
    
    private func subscribeToNetworkStatus() {
        networkStatusMonitor.$isNetworkAvailable
            .sink { [weak self] isAvailable in
                guard let self else { return }
                if !isAvailable {
                    let message = LocalizedString.Errors.noInternet.localized
                    router.navigate(to: .showAlert(message))
                }
            }
            .store(in: &cancellables)
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
                let response = try await moviesService.getPopularMovies(page: page)
                let moviesPage = response.results.map { Movie.ViewModel(response: $0) }
                let uniqueMovies = moviesPage.filter { newMovie in
                    !self.movies.contains(where: { $0.id == newMovie.id })
                }
                self.movies.append(contentsOf: uniqueMovies)
                self.totalPages = response.totalPages
                sortMovies(by: currentSortOption)
            } catch let error as ApiError {
                router.navigate(to: .showAlert(error.message))
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
                let response = try await moviesService.getGenres()
                let genreDict = response.genres.reduce(into: [Int: String]()) { dict, genre in
                    dict[genre.id] = genre.name
                }
                AppUserDefaults.genres = genreDict
            } catch let error as ApiError {
                router.navigate(to: .showAlert(error.message))
            }
            output.send(.spinner(state: false))
        }
    }
}
