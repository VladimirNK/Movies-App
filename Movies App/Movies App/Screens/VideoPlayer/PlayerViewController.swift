//
//  PlayerViewController.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 28.06.2024.
//

import Foundation
import YouTubeiOSPlayerHelper

final class PlayerViewController: ViewController<PlayerViewModel> {
    
    // MARK: - UI Elements
    
    private lazy var playerView: YTPlayerView = .build {
        $0.delegate = self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        input.send(.viewDidLoad)
    }
    
    // MARK: - Bind ViewModel
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .play(key: let key):
                    playerView.load(withVideoId: key)
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .black
        addViews()
        setupConstraints()
    }
    
    private func addViews() {
        view.addSubview(playerView)
    }
    
    private func setupConstraints() {
        playerView.snp.makeConstraints {
            $0.height.equalTo(Constants.VideoPlayer.playerHeight)
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

//MARK: - YTPlayerViewDelegate

extension PlayerViewController: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
