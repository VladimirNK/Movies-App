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
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        searchBar.searchBarStyle = .default
        searchBar.tintColor = .black
        return searchBar
    }()
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        collectionView.register(MovieCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
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
        view.text = "Nothing Found"
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
        title = "Popular Movies"
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "slider.horizontal.3")
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
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        moviesCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
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
                case .fetchMoviesDidFail(let error):
                    print(error)
                case .updateMovies(let movies):
                    self.movies = movies
                    moviesCollectionView.reloadData()
                    nothingFoundLabel.isHidden = !movies.isEmpty
                case .spinner(state: let bool):
                    bool ? spinner.startAnimating() : spinner.stopAnimating()
                case .sort(selected: let selected, movies: let movies):
                    break
                case .endRefreshing:
                    refreshControl.endRefreshing()
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
        let lessTotalPages = vm.currentPage < vm.totalPages
        
        /// Movies count offset to make pagination less noticeable to the user
        let loadingOffset = 5
        
        // TODO: - when we scroll to top we have redunant API call
        if lessTotalPages && (indexPath.row == vm.movies.count - loadingOffset) {
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
        let cellHeight: CGFloat = cellWidth * 0.65
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

//MARK: - UISearchResultsUpdating

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        input.send(.searchBar(text: searchText))
    }
}
