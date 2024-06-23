//
//  BaseViewController.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import UIKit
import Combine

class ViewController<ViewModel: ViewModelProtocol>: UIViewController {
    
    // MARK: - UI Elements
    
    
    
    
    // MARK: - Properties
    
    let viewModel: ViewModel
    let input: PassthroughSubject<ViewModel.Input, Never> = .init()
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
