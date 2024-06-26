//
//  MoviesRouter.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

enum SortOption: String, CaseIterable {
    case alphabet = "Alphabet"
    case releaseDate = "Release Date"
    case userScore = "User Score"
}

enum MoviesRoute {
    case details(movieId: Int)
    case sort(current: SortOption, onSelect: ((SortOption) -> Void)?)
}

protocol MoviesRouter {
    func navigate(to route: MoviesRoute)
}

final class MoviesRouterImpl: MoviesRouter {
    
    weak var view: UIViewController?
    
    func navigate(to route: MoviesRoute) {
        switch route {
        case .details(let movieId):
            navigateToDetails(movieId: movieId)
        case .sort(let current, let onSelect):
            showSortActionSheet(current: current, onSelect: onSelect)
        }
    }
    
    private func navigateToDetails(movieId: Int) {
        guard let navController = view?.navigationController else { return }
        let vc = DetailsAssembly(id: movieId).assemble()
        vc.navigationItem.largeTitleDisplayMode = .never
        navController.pushViewController(vc, animated: true)
    }
    
    private func showSortActionSheet(current: SortOption, onSelect: ((SortOption) -> Void)?) {
        guard let view = view else { return }
        
        let alert = UIAlertController(title: "Sorted By:", message: nil, preferredStyle: .actionSheet)
        
        let actions = SortOption.allCases.map { option -> UIAlertAction in
            let action = UIAlertAction(
                title: option.rawValue,
                style: .default,
                handler: { _ in
                    onSelect?(option)
                })
            if option == current {
                action.setValue(true, forKey: "checked")
            }
            return action
        }
        
        actions.forEach { alert.addAction($0) }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        view.present(alert, animated: true, completion: nil)
    }

    
}
