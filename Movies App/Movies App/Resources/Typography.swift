//
//  Typography.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import UIKit

enum Typography {
    case title
    case subtitle
    case body
    case small
    
    var font: UIFont {
        switch self {
        case .title: return UIFont.systemFont(ofSize: 24, weight: .bold)
        case .subtitle: return UIFont.systemFont(ofSize: 18, weight: .medium)
        case .body: return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .small: return UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
}

extension UIFont {
    static func typography(_ style: Typography) -> UIFont {
        return style.font
    }
}
