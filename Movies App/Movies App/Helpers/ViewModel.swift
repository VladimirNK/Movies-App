//
//  ViewModel.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import UIKit
import Combine

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var output: PassthroughSubject<Output, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}


class ViewModel<Input, Output>: ViewModelProtocol {
    
    var output: PassthroughSubject<Output, Never> = .init()
    var cancellables: Set<AnyCancellable> = []
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        fatalError("transform(input:) must be overridden")
    }
}
