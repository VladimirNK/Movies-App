//
//  MoviesViewController.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import UIKit
import Combine

final class MoviesViewController: ViewController<MoviesViewModel> {
    
    // MARK: - UI Elements
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(MovieCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return collectionView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .black
        return view
    }()
    
    // MARK: - Properties
    
    private var movies: [Movie.ViewModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        input.send(.viewDidLoad)
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        view.backgroundColor = .black
        addViews()
        setupConstraints()
        title = "Title goes here"
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let sortButton = UIBarButtonItem(systemItem: .refresh)
        sortButton.target = self
        sortButton.action = #selector(sortButtonTapped)
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func addViews() {
        view.addSubview(moviesCollectionView)
        view.addSubview(spinner)
    }
    
    private func setupConstraints() {
        moviesCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func buttonDidTap() {
        input.send(.refreshButtonDidTap)
    }
    
    @objc func sortButtonTapped() {
        print("Sort button tapped!")
    }
    
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchMoviesDidFail(let error):
                    print(error)
                case .fetchMoviesDidSucceed(let movies):
                    self.movies = movies
                    moviesCollectionView.reloadData()
                case .spinner(state: let bool):
                    bool ? spinner.startAnimating() : spinner.stopAnimating()
                }
            }.store(in: &cancellables)
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        input.send(.cellDidTap)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
}

// MARK: - UICollectionViewDataSource

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MovieCell.self, for: indexPath)
        let model = movies[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.adjustedContentInset
        let cellWidth = collectionView.bounds.width - contentInset.left - contentInset.right
        let cellHeight: CGFloat = cellWidth / 2
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
