//
//  UIImageView+Extension.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(from urlString: String, placeholderImage: UIImage? = UIImage(systemName: "photo")) {
        self.sd_setImage(with: URL(string: urlString), placeholderImage: placeholderImage, options: [], completed: { [weak self] image, error, _, _ in
            if error != nil {
                self?.image = placeholderImage
            } else {
                self?.image = image
            }
        })
    }
}

