//
//  MoviesAssembly.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import UIKit

final class MoviesAssembly {
    
    func assemble() -> UIViewController {
        let router = MoviesRouterImpl()
        let moviesService = MoviesServiceImpl()
        let viewModel = MoviesViewModel(router: router, moviesService: moviesService)
        let viewController = MoviesViewController(viewModel: viewModel)
        router.view = viewController
        return viewController
    }
}
