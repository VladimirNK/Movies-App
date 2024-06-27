//
//  DetailsViewController.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

final class DetailsViewController: ViewController<DetailsViewModel> {
    
    // MARK: - UI Elements
    
    private lazy var movieTitle: UILabel = {
        let view = UILabel()
        view.font = .typography(.title)
        view.textColor = .black
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var countryLabel: UILabel = {
        let view = UILabel()
        view.font = .typography(.subtitle)
        view.textColor = .darkGray
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var genresLabel: UILabel = {
        let view = UILabel()
        view.font = .typography(.body)
        view.textColor = .red
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var movieDescriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .typography(.body)
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var ratingLabel: UILabel = {
        let view = UILabel()
        view.font = .typography(.body)
        view.textColor = .black
        return view
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(posterImageTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var trailerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play.rectangle")
        config.title = "Play Trailer"
        config.imagePadding = Space.xs
        config.imagePlacement = .leading
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(trailerButtonDidTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var descriptionStack: UIStackView = {
        let subviews = [
            movieTitle,
            countryLabel,
            genresLabel,
            ratingLabel,
            trailerButton,
            movieDescriptionLabel
        ]
        let view = UIStackView(arrangedSubviews: subviews)
        view.axis = .vertical
        view.spacing = Space.m
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        input.send(.viewDidLoad)
    }
    
    // MARK: - Setup UI
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .success(movie: let movie):
                    configureContent(with: movie)
                case .spinner(state: let loading):
                    loading ? spinner.startAnimating() : spinner.stopAnimating()
                }
            }.store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        addViews()
        setupConstraints()
    }
    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(descriptionStack)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).dividedBy(3)
        }
        
        trailerButton.snp.makeConstraints {
            $0.height.equalTo(Space.xl5)
        }
        
        descriptionStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Space.m)
            $0.top.equalTo(posterImageView.snp.bottom).offset(Space.xs)
            $0.bottom.equalToSuperview().inset(Space.m)
        }
    }
    
    private func configureContent(with movie: MovieItem.ViewModel) {
        self.title = movie.title
        posterImageView.loadImage(from: movie.posterPath)
        movieTitle.text = movie.title
        countryLabel.text = formatCountries(from: movie, localeId: "en_US")
        genresLabel.text = movie.genres.joined(separator: ", ")
        movieDescriptionLabel.text = movie.overview
        ratingLabel.text = formatRating(movie.voteAverage)
    }
    
    private func countryName(from countryCode: String, localeId: String) -> String? {
        let locale = Locale(identifier: localeId) // "en_US"
        return locale.localizedString(forRegionCode: countryCode)
    }
    
    private func formatCountries(from model: MovieItem.ViewModel, localeId: String) -> String {
        let countries = model.originCountry.compactMap { countryName(from: $0, localeId: localeId) }
        let countriesString = countries.joined(separator: ", ")
        let releaseYearString = model.releaseDate.yearAsString()
        return countriesString + " (\(releaseYearString))"
    }
    
    private func formatGenres(from indices: [Int]) -> String {
        guard let genreDict = AppUserDefaults.genres else {
            return ""
        }
        let genreNames = indices.compactMap { genreDict[$0] }
        return genreNames.joined(separator: ", ")
    }
    
    private func formatRating(_ value: Double) -> String {
        let ratingString  = String(format: "%.1f", value)
        return "User Score: \(ratingString)"
    }
    
    @objc private func trailerButtonDidTap() {
        
    }
    
    @objc private func posterImageTapped() {
        guard let image = posterImageView.image else { return }
        input.send(.posterDidTap(image: image))
    }
}
