//
//  CGSize+Extension.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

extension CGSize {
    init(square side: CGFloat) {
        self.init(width: side, height: side)
    }
}
