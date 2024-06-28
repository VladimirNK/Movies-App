//
//  PlayerViewModel.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 28.06.2024.
//

import UIKit
import Combine

final class PlayerViewModel: ViewModel<PlayerViewModel.Input, PlayerViewModel.Output> {
    
    enum Input {
        case viewDidLoad
    }
    
    enum Output {
        case play(key: String)
    }
    
    // MARK: - Properties
    
    private let movieKey: String
    
    // MARK: - Init
    
    init(movieKey: String) {
        self.movieKey = movieKey
        super.init()
    }
    
    // MARK: - Transform
    
    override func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                output.send(.play(key: movieKey))
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
