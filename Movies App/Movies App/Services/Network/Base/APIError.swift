//
//  APIError.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

struct ApiError: Error {

    var statusCode: Int!
    let errorCode: Int
    let message: String
    let success: Bool

    init(statusCode: Int = 0, errorCode: Int, message: String, success: Bool = false) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
        self.success = success
    }

    private enum CodingKeys: String, CodingKey {
        case errorCode = "status_code"
        case message = "status_message"
        case success
    }
}

extension ApiError: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(Int.self, forKey: .errorCode)
        message = try container.decode(String.self, forKey: .message)
        success = try container.decode(Bool.self, forKey: .success)
    }
}
