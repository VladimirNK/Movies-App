//
//  MoviesRouter.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

enum SortOption: String, CaseIterable {
    case releaseDate = "Release Date"
    case userScore = "User Score"
}

enum MoviesRoute {
    case details
    case sort(current: SortOption, onSelect: (SortOption) -> Void)
}

protocol MoviesRouter {
    func navigate(to route: MoviesRoute)
}

final class MoviesRouterImpl: MoviesRouter {
    
    weak var view: UIViewController?
    
    func navigate(to route: MoviesRoute) {
        switch route {
        case .details:
            navigateToDetails()
        case .sort(let current, let onSelect):
            break
        }
    }
    
    private func navigateToDetails() {
        guard let navController = view?.navigationController else { return }
        let vc = DetailsAssembly().assemble()
        vc.title = "Some title"
        vc.navigationItem.largeTitleDisplayMode = .never
        navController.pushViewController(vc, animated: true)
    }
    
}
