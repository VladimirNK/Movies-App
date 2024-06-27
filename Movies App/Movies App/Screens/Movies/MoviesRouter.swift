//
//  MoviesRouter.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

enum SortOption: CaseIterable {
    case alphabet
    case releaseDate
    case userScore
    
    var name: String {
        switch self {
        case .alphabet:
            return LocalizedString.SortOptions.alphabet.localized
        case .releaseDate:
            return LocalizedString.SortOptions.releaseDate.localized
        case .userScore:
            return LocalizedString.SortOptions.userScore.localized
        }
    }
}

enum MoviesRoute {
    case details(movieId: Int)
    case sort(current: SortOption, onSelect: ((SortOption) -> Void)?)
    case showAlert(String)
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
        case .showAlert(let text):
            showAlert(title: text)
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
        
        let title = LocalizedString.MoviesScreen.sortedBy.localized
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let actions = SortOption.allCases.map { option -> UIAlertAction in
            let action = UIAlertAction(
                title: option.name,
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
        
        let cancelActionTitle = LocalizedString.MoviesScreen.cancel.localized
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        view.present(alert, animated: true, completion: nil)
    }

    private func showAlert(title: String) {
        guard let view else { return }
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okTitle = LocalizedString.MoviesScreen.ok.localized
        let okAction = UIAlertAction(title: okTitle, style: .default)
        alertController.addAction(okAction)
        view.present(alertController, animated: true, completion: nil)
    }
}
