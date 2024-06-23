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
    
    private lazy var tableView: UITableView = .build {
        $0.delegate = self
        $0.dataSource = self
        $0.register(MovieCell.self)
    }
    
    private lazy var getMoviesButton: UIButton = .build {
        $0.setTitle("Get movies", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    private lazy var errorLabel: UILabel = .build {
        $0.textColor = .red
        $0.textAlignment = .center
    }
    
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
        view.addSubview(tableView)
        view.addSubview(getMoviesButton)
        view.addSubview(errorLabel)
        view.addSubview(spinner)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        getMoviesButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
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
                    errorLabel.text = error.message
                case .fetchMoviesDidSucceed(let movies):
                    self.movies = movies
                    tableView.reloadData()
                case .toggleButton(let isEnabled):
                    getMoviesButton.isEnabled = isEnabled
                case .spinner(state: let bool):
                    bool ? spinner.startAnimating() : spinner.stopAnimating()
                }
            }.store(in: &cancellables)
    }
    
    
}

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        input.send(.cellDidTap)
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MovieCell.self, for: indexPath)
        let model = movies[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    
}
