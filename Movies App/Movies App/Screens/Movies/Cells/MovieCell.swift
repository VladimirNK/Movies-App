//
//  MovieCell.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import UIKit
import SnapKit
import SDWebImage

final class MovieCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private lazy var posterImageView: UIImageView = .build {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = CornerRadius.s
        $0.clipsToBounds = true
    }
    
    private lazy var movieTitle: UILabel = .build {
        $0.textColor = .white
        $0.font = .typography(.title)
        $0.numberOfLines = 2
    }
    
    private lazy var releaseDateLabel: UILabel = .build {
        $0.textColor = .white
        $0.font = .typography(.subtitle)
    }
    
    private lazy var genresContainer: UIView = .build {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private lazy var genresLabel: UILabel = .build {
        $0.textColor = .white
        $0.font = .typography(.body)
        $0.numberOfLines = 2
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.8).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }()
    
    private lazy var ratingView = RatingView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(
            x: .zero,
            y: .zero,
            width: contentView.bounds.width,
            height: contentView.bounds.height / 2
        )
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowRadius = CornerRadius.xs
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.black.cgColor
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = CornerRadius.l
    }
    
    private func addViews() {
        contentView.addSubview(posterImageView)
        posterImageView.layer.addSublayer(gradientLayer)
        posterImageView.addSubview(movieTitle)
        posterImageView.addSubview(releaseDateLabel)
        posterImageView.addSubview(genresContainer)
        genresContainer.addSubview(genresLabel)
        posterImageView.addSubview(ratingView)
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Space.xs3)
        }
        
        movieTitle.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(Space.m)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Space.m)
            $0.top.equalTo(movieTitle.snp.bottom).offset(Space.xs3)
        }
        
        genresContainer.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        genresLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Space.xs)
        }
        
        ratingView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Space.m)
        }
    }
    
    // MARK: - Formatters
    
    private func genreNames(from indices: [Int]) -> String {
        guard let genreDict = AppUserDefaults.genres else {
            return .empty
        }
        let genreNames = indices.compactMap { genreDict[$0] }
        return genreNames.joined(separator: ", ")
    }
    
    // MARK: - Configure cell
    
    public func configure(with model: Movie.ViewModel) {
        movieTitle.text = model.title
        posterImageView.loadImage(from: model.posterPath)
        releaseDateLabel.text = model.releaseDate.yearAsString()
        genresLabel.text = genreNames(from: model.genreIDS)
        let roundedRating = model.voteAverage.roundedToWholeNumber()
        ratingView.setProgress(to: roundedRating)
    }
}
