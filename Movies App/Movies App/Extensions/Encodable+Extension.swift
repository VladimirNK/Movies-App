//
//  Encodable+Extension.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

extension Encodable {
    
    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var toQueryItems: [URLQueryItem]? {
        guard let dictionary = self.toDictionary else { return nil }
        return dictionary.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
}
