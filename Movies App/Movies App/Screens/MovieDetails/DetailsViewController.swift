//
//  DetailsViewController.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

final class DetailsViewController: ViewController<DetailsViewModel> {
    
    // MARK: - UI Elements
    
    private lazy var movieTitleLabel: UILabel = .build {
        $0.font = .typography(.title)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private lazy var countryLabel: UILabel = .build {
        $0.font = .typography(.subtitle)
        $0.textColor = .darkGray
        $0.numberOfLines = 2
    }
    
    private lazy var genresLabel: UILabel = .build {
        $0.font = .typography(.body)
        $0.textColor = .red
        $0.numberOfLines = 2
    }
    
    private lazy var movieDescriptionLabel: UILabel = .build {
        $0.font = .typography(.body)
        $0.textColor = .black
        $0.numberOfLines = .zero
    }
    
    private lazy var ratingLabel: UILabel = .build {
        $0.font = .typography(.body)
        $0.textColor = .black
    }
    
    private lazy var spinner: UIActivityIndicatorView = .build {
        $0 = UIActivityIndicatorView(style: .large)
        $0.color = .black
    }
    
    private lazy var posterImageView: UIImageView = .build {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(posterImageTapped))
        $0.addGestureRecognizer(tapGesture)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var trailerButton: UIButton = .build {
        var config = UIButton.Configuration.filled()
        config.image = SystemIcons.play.image
        config.title = LocalizedString.MovieDetailsScreen.playTrailer.localized
        config.imagePadding = Space.xs
        config.imagePlacement = .leading
        $0 = UIButton(configuration: config)
        $0.addTarget(self, action: #selector(trailerButtonDidTap), for: .touchUpInside)
        $0.isHidden = true
    }
    
    private lazy var descriptionStack: UIStackView = .build {
        let subviews = [
            movieTitleLabel,
            countryLabel,
            genresLabel,
            ratingLabel,
            trailerButton,
            movieDescriptionLabel
        ]
        $0 = UIStackView(arrangedSubviews: subviews)
        $0.axis = .vertical
        $0.spacing = Space.m
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var scrollView: UIScrollView = .build {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var contentView = UIView()
    
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
                case .success(movie: let movie):
                    configureContent(with: movie)
                case .spinner(state: let loading):
                    loading ? spinner.startAnimating() : spinner.stopAnimating()
                case .didFetchTrailer(let hasTrailer):
                    trailerButton.isHidden = !hasTrailer
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    
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
    
    // MARK: - Configure dcreen data
    
    private func configureContent(with movie: MovieItem.ViewModel) {
        self.title = movie.title
        posterImageView.loadImage(from: movie.posterPath)
        movieTitleLabel.text = movie.title
        countryLabel.text = formatCountries(from: movie, localeId: .localeIdentifier)
        genresLabel.text = movie.genres.joined(separator: .commaSeparator)
        movieDescriptionLabel.text = movie.overview
        ratingLabel.text = formatRating(movie.voteAverage)
    }
    
    // MARK: - Format strings
    
    private func countryName(from countryCode: String, localeId: String) -> String? {
        let locale = Locale(identifier: localeId)
        return locale.localizedString(forRegionCode: countryCode)
    }
    
    private func formatCountries(from model: MovieItem.ViewModel, localeId: String) -> String {
        let countries = model.originCountry.compactMap { countryName(from: $0, localeId: localeId) }
        let countriesString = countries.joined(separator: .commaSeparator)
        let releaseYearString = model.releaseDate.yearAsString()
        return countriesString + " (\(releaseYearString))"
    }
    
    private func formatGenres(from indices: [Int]) -> String {
        guard let genreDict = AppUserDefaults.genres else {
            return .empty
        }
        let genreNames = indices.compactMap { genreDict[$0] }
        return genreNames.joined(separator: .commaSeparator)
    }
    
    private func formatRating(_ value: Double) -> String {
        let ratingString = String(format: "%.1f", value)
        let key = LocalizedString.MovieDetailsScreen.rating.localized
        return "\(key): \(ratingString)"
    }
    
    // MARK: - Actions
    
    @objc private func trailerButtonDidTap() {
        input.send(.showTrailerDidTap)
    }
    
    @objc private func posterImageTapped() {
        guard let image = posterImageView.image else { return }
        input.send(.posterDidTap(image: image))
    }
}
