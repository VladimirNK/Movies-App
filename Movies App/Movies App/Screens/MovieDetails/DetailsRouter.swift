//
//  DetailsRouter.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

enum DetailsRoute {
    case pop
}

protocol DetailsRouter {
    func navigate(to route: DetailsRoute)
}

final class DetailsRouterImpl: DetailsRouter {
    
    weak var view: UIViewController?
    
    func navigate(to route: DetailsRoute) {
        switch route {
        case .pop:
            navigateBack()
        }
    }
    
    private func navigateBack() {
        guard let navController = view?.navigationController else { return }
        navController.popViewController(animated: true)
    }
}
