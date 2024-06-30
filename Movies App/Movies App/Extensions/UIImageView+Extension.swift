//
//  UIImageView+Extension.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    private static var tintedPlaceholderImage: UIImage? = {
        let placeholderImage = SystemIcons.photo.image
        let placeholderTintColor = UIColor.darkGray
        return placeholderImage?.withTintColor(placeholderTintColor, renderingMode: .alwaysOriginal)
    }()
    
    func loadImage(from urlString: String, placeholderImage: UIImage? =  UIImageView.tintedPlaceholderImage) {
        let url = URL(string: urlString)
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: [], completed: { [weak self] image, error, _, _ in
            if error != nil {
                self?.image = placeholderImage
            } else {
                self?.image = image
            }
        })
    }
}

