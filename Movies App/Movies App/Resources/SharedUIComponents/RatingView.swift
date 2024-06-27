//
//  RatingView.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit
import SnapKit

class RatingView: UIView {
    
    private lazy var shapeLayer: CAShapeLayer = .build {
        $0.fillColor = UIColor.clear.cgColor
        $0.strokeColor = UIColor.green.cgColor
        $0.lineCap = .round
        $0.lineWidth = Space.xs3
    }
    
    private lazy var backgroundLayer: CAShapeLayer = .build {
        $0.fillColor = UIColor.clear.cgColor
        $0.strokeColor = UIColor.green.withAlphaComponent(0.3).cgColor
        $0.lineCap = .round
        $0.lineWidth = Space.xs3
    }
    
    private lazy var percentageLabel: UILabel = .build {
        $0.textAlignment = .center
        $0.font = .typography(.body)
        $0.textColor = .white
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    private func setupView() {
        backgroundColor = .black.withAlphaComponent(0.9)
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(shapeLayer)
        addSubview(percentageLabel)
    }
    
    private func setupConstraints() {
        percentageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setProgress(to progress: Double) {
        let clampedProgress = min(max(progress, 0), 10) / 10
        percentageLabel.text = "\(Int(clampedProgress * 100))%"
        shapeLayer.strokeEnd = CGFloat(clampedProgress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.width / 2
        
        let insetBounds = bounds.insetBy(dx: Space.xs2, dy: Space.xs2)
        let diameter = min(insetBounds.width, insetBounds.height)
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            radius: diameter / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )
        
        backgroundLayer.path = circularPath.cgPath
        shapeLayer.path = circularPath.cgPath
        backgroundLayer.frame = bounds
        shapeLayer.frame = bounds
    }
}

