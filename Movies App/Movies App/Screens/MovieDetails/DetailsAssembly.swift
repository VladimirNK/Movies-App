//
//  DetailsAssembly.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

final class DetailsAssembly {
    
    func assemble() -> UIViewController {
        let router = DetailsRouterImpl()
        let moviesService = MoviesServiceImpl()
        let viewModel = DetailsViewModel(router: router, moviesService: moviesService)
        let viewController = DetailsViewController(viewModel: viewModel)
        router.view = viewController
        return viewController
    }
}
