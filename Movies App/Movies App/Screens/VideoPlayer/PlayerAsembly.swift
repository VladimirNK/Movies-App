//
//  PlayerAsembly.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 28.06.2024.
//

import UIKit

final class PlayerAsembly {
    
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func assemble() -> UIViewController {
        let viewModel = PlayerViewModel(movieKey: key)
        let viewController = PlayerViewController(viewModel: viewModel)
        return viewController
    }
}
