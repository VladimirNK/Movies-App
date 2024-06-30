//
//  PosterViewController.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 26.06.2024.
//

import UIKit

final class PosterViewController: ViewController<PosterViewModel> {
    
    // MARK: - UI Elements
    
    private lazy var posterImageView: UIImageView = .build {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(onDismiss))
        swipeDownGesture.direction = .down
        $0.addGestureRecognizer(swipeDownGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        $0.addGestureRecognizer(pinchGesture)
    }
    
    private lazy var closeButton: UIButton = .build {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: Space.xl5, weight: .bold, scale: .small)
        let largeBoldDoc = SystemIcons.close.image?.applyingSymbolConfiguration(largeConfig)
        $0.setImage(largeBoldDoc, for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
    }
    
    private lazy var scrollView: UIScrollView = .build {
        $0.minimumZoomScale = 1.0
        $0.maximumZoomScale = 3.0
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.addSubview(posterImageView)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        input.send(.viewDidLoad)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        addViews()
        setupConstraints()
    }
    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(posterImageView)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Space.m)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Space.m)
        }
    }
    
    // MARK: - ViewModel Binding
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .presentImage(let image):
                    self.posterImageView.image = image
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - Gesture Handling
    
    @objc private func onDismiss() {
        input.send(.dismiss)
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        if gesture.state == .changed || gesture.state == .ended {
            let currentScale = view.frame.size.width / view.bounds.size.width
            var newScale = currentScale * gesture.scale
            
            if newScale < scrollView.minimumZoomScale {
                newScale = scrollView.minimumZoomScale
            } else if newScale > scrollView.maximumZoomScale {
                newScale = scrollView.maximumZoomScale
            }
            
            scrollView.zoomScale = newScale
            gesture.scale = 1.0
        }
    }
}

//MARK: - UIScrollViewDelegate

extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = posterImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ?
        (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ?
        (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
    }
}
