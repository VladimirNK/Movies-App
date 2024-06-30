//
//  Double+Extension.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

extension Double {
    
    func roundedToWholeNumber() -> Double {
        return (self * 10).rounded() / 10
    }
}
