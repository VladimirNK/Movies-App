//
//  MovieCell.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import UIKit
import SnapKit

final class MovieCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private lazy var posterImageView: UIImageView = .build {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var title: UILabel = .build {
        $0.textColor = .black
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: Movie.ViewModel) {
        self.title.text = model.title
    }
    
    // MARK: - Private methods
    
    private func addViews() {
        //contentView.addSubview(posterImageView)
        contentView.addSubview(title)
    }
    
    private func setupConstraints() {
//        posterImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
