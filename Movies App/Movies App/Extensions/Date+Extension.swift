//
//  Date+Extension.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

extension Date {
    ///Extract year String from Date
    func yearAsString() -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return String(year)
    }
}
