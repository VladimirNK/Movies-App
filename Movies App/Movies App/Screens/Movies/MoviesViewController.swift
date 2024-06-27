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
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = LocalizedString.SearchBar.placeholder.localized
        searchBar.delegate = self
        searchBar.searchBarStyle = .default
        searchBar.tintColor = .black
        return searchBar
    }()
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Space.m
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        collectionView.register(MovieCell.self)
        let insets = UIEdgeInsets(top: .zero, left: Space.m, bottom: Space.m, right: Space.m)
        collectionView.contentInset = insets
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return view
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        return view
    }()
    
    private lazy var nothingFoundLabel: UILabel = {
        let view = UILabel()
        view.text = LocalizedString.MoviesScreen.searchNothingFound.localized
        view.font = .typography(.body)
        view.textColor = .black
        view.isHidden = true
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
        view.backgroundColor = .white
        addViews()
        setupConstraints()
        title = LocalizedString.MoviesScreen.title.localized
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let image = SystemIcons.sort.image
        let sortButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func addViews() {
        view.addSubview(searchBar)
        view.addSubview(moviesCollectionView)
        view.addSubview(spinner)
        view.addSubview(nothingFoundLabel)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Space.m)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        moviesCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(Space.m)
        }
        
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        nothingFoundLabel.snp.makeConstraints {
            $0.center.equalTo(moviesCollectionView)
        }
    }
    
    @objc func didPullToRefresh() {
        input.send(.didPullToRefresh)
    }
    
    @objc func sortButtonTapped() {
        input.send(.sortDidTap(completion: { [weak self] sortOption in
            guard let self else { return }
            input.send(.sortSelected(sortOption))
        }) )
    }
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .success(let movies):
                    self.movies = movies
                    moviesCollectionView.reloadData()
                    nothingFoundLabel.isHidden = !movies.isEmpty
                case .spinner(state: let loading):
                    loading ? spinner.startAnimating() : spinner.stopAnimating()
                case .endRefreshing:
                    refreshControl.endRefreshing()
                }
            }.store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        input.send(.cellDidTap(movie: movie))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lessTotalPages = vm.currentPage < vm.totalPages
        
        if lessTotalPages && (indexPath.row == movies.count - Constants.MoviesScreen.paginationOffset) {
            input.send(.fetchMoreMovies)
        }
        
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
        let cellHeight: CGFloat = cellWidth * Constants.MoviesScreen.movieCellHeightMultiplier
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

//MARK: - UISearchResultsUpdating

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        input.send(.searchBar(text: searchText))
    }
}
