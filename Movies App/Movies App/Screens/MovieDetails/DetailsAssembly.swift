//
//  DetailsAssembly.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

final class DetailsAssembly {
    
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func assemble() -> UIViewController {
        let router = DetailsRouterImpl()
        let moviesService = MoviesServiceImpl()
        let networkStatusMonitor = NetworkStatusMonitor()
        let viewModel = DetailsViewModel(
            movieId: id,
            router: router,
            moviesService: moviesService,
            networkStatusMonitor: networkStatusMonitor
        )
        let viewController = DetailsViewController(viewModel: viewModel)
        router.view = viewController
        return viewController
    }
}
