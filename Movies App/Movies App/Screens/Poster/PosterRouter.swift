//
//  PosterRouter.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 26.06.2024.
//

import UIKit

enum PosterRoute {
    case dismiss
}

protocol PosterRouter {
    func navigate(to route: PosterRoute)
}

final class PosterRouterImpl: PosterRouter {
    
    weak var view: UIViewController?
    
    func navigate(to route: PosterRoute) {
        switch route {
        case .dismiss:
            guard let view else { return }
            view.dismiss(animated: true, completion: nil)
        }
    }
}
