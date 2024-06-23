//
//  MoviesAssembly.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import UIKit

final class MoviesAssembly {
    
    func assemble() -> UIViewController {
        let moviesService = MoviesServiceImpl()
        let viewModel = MoviesViewModel(moviesService: moviesService)
        return MoviesViewController(viewModel: viewModel)
    }
}
