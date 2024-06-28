//
//  Localizable.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 27.06.2024.
//

import Foundation

protocol Localizable: RawRepresentable where RawValue == String {
    var localized: String { get }
}

extension Localizable {
    var localized: String {
        return NSLocalizedString(rawValue, comment: .empty)
    }
}
