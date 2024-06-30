//
//  SystemIcons.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 27.06.2024.
//

import UIKit

enum SystemIcons {
    case sort
    case play
    case close
    case photo
    
    var image: UIImage? {
        switch self {
        case .sort:
            return UIImage(systemName: "slider.horizontal.3")
        case .play:
            return UIImage(systemName: "play.rectangle")
        case .close:
            return UIImage(systemName: "xmark.circle.fill")
        case .photo:
            return UIImage(systemName: "photo")
        }
    }
}


