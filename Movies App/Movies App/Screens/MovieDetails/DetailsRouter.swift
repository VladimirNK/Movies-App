//
//  DetailsRouter.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

enum DetailsRoute {
    case pop
    case showPoster(UIImage)
    case showAlert(String)
    case showTrailer(key: String)
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
        case .showPoster(let image):
            showPoster(image)
        case .showAlert(let text):
            showAlert(title: text)
        case .showTrailer(key: let key):
            showTrailer(key: key)
        }
    }
    
    private func navigateBack() {
        guard let navController = view?.navigationController else { return }
        navController.popViewController(animated: true)
    }
    
    private func showPoster(_ image: UIImage) {
        guard let view else { return }
        let posterVC = PosterAssembly(poster: image).assemble()
        posterVC.modalPresentationStyle = .fullScreen
        view.present(posterVC, animated: true)
    }
    
    private func showAlert(title: String) {
        guard let view else { return }
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        view.present(alertController, animated: true, completion: nil)
    }
    
    private func showTrailer(key: String) {
        guard let view else { return }
        let trailerVC = PlayerAsembly(key: key).assemble()
        trailerVC.modalPresentationStyle = .automatic
        view.present(trailerVC, animated: true)
    }
}
