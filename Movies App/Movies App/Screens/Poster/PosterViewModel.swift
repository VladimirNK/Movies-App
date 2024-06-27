//
//  PosterViewModel.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 26.06.2024.
//

import UIKit
import Combine

final class PosterViewModel: ViewModel<PosterViewModel.Input, PosterViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case dismiss
    }
    
    enum Output {
        case presentImage(UIImage)
    }
    
    // MARK: - Properties
    
    private let router: PosterRouter
    private let poster: UIImage
    
    // MARK: - Init
    
    init(router: PosterRouter, poster: UIImage) {
        self.router = router
        self.poster = poster
    }
    
    // MARK: - Transform
    
    override func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                output.send(.presentImage(poster))
            case .dismiss:
                router.navigate(to: .dismiss)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
