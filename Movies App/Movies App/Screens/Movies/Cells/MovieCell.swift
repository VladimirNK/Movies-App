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
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private lazy var movieName: UILabel = .build {
        $0.textColor = .black
    }
    
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
    
    // MARK: - Methods
    
    private func setupUI() {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
    }
    
    public func configure(with model: Movie.ViewModel) {
        movieName.text = model.title
        posterImageView.loadImage(from: model.posterPath)
    }
    
    // MARK: - Private methods
    
    private func addViews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieName)
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        movieName.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
