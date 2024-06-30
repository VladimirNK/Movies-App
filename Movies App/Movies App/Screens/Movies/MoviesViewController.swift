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
    
    private lazy var searchBar: UISearchBar = .build {
        $0.placeholder = LocalizedString.SearchBar.placeholder.localized
        $0.delegate = self
        $0.searchBarStyle = .default
        $0.tintColor = .black
    }
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Space.m
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.refreshControl = refreshControl
        view.register(MovieCell.self)
        let insets = UIEdgeInsets(top: .zero, left: Space.m, bottom: Space.m, right: Space.m)
        view.contentInset = insets
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = .build {
        $0.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private lazy var spinner: UIActivityIndicatorView = .build {
        $0 = UIActivityIndicatorView(style: .large)
        $0.color = .black
    }
    
    private lazy var nothingFoundLabel: UILabel = .build {
        $0.text = LocalizedString.MoviesScreen.searchNothingFound.localized
        $0.font = .typography(.body)
        $0.textColor = .black
        $0.isHidden = true
    }
    
    // MARK: - Properties
    
    private var movies: [Movie.ViewModel] = []
    
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
                case .success(let movies):
                    handleDidSuccess(with: movies)
                case .spinner(state: let loading):
                    loading ? spinner.startAnimating() : spinner.stopAnimating()
                case .endRefreshing:
                    refreshControl.endRefreshing()
                case .didSorted(movies: let movies):
                    handleDidSort(with: movies)
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    
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
    
    //MARK: - Actions
    
    @objc func didPullToRefresh() {
        input.send(.didPullToRefresh)
    }
    
    @objc func sortButtonTapped() {
        input.send(.sortDidTap(completion: { [weak self] sortOption in
            guard let self else { return }
            input.send(.sortSelected(sortOption))
        }) )
    }
    
    private func handleDidSuccess(with movies: [Movie.ViewModel]) {
        self.movies = movies
        moviesCollectionView.reloadData()
        nothingFoundLabel.isHidden = !movies.isEmpty
    }
    
    private func handleDidSort(with movies: [Movie.ViewModel]) {
        self.movies = movies
        moviesCollectionView.reloadData()
        let firstIndexPath = IndexPath(item: 0, section: 0)
        moviesCollectionView.scrollToItem(at: firstIndexPath, at: .top, animated: true)
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
