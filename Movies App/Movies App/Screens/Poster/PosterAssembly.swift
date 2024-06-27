//
//  PosterAssembly.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 26.06.2024.
//

import UIKit

final class PosterAssembly {
    
    private let poster: UIImage
    
    init(poster: UIImage) {
        self.poster = poster
    }
    
    func assemble() -> UIViewController {
        let router = PosterRouterImpl()
        let viewModel = PosterViewModel(router: router, poster: poster)
        let viewController = PosterViewController(viewModel: viewModel)
        router.view = viewController
        return viewController
    }
}
