//
//  DetailsViewModel.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

final class DetailsViewModel: ViewModel<DetailsViewModel.Input, DetailsViewModel.Output> {
    
    enum Input {
        
    }
    
    enum Output {
        
    }
    
    // MARK: - Properties
    
    private let router: DetailsRouter
    private let moviesService: MoviesService
    
    // MARK: - Init
    
    init(router: DetailsRouter, moviesService: MoviesService) {
        self.router = router
        self.moviesService = moviesService
    }
}
