//
//  Endpoint.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var token: String { get }
    var method: RequestMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var scheme: String {
        return Constants.API.scheme
    }
    
    var host: String {
        return Constants.API.host
    }
    
    var token: String {
        return Constants.API.accessToken
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host =  host
        urlComponents.path = path
        
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw ApiError(errorCode: 0, message: "URL error")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue(Constants.Header.contentTypeValue, forHTTPHeaderField: Constants.Header.acceptKey)
        urlRequest.addValue(Constants.Header.contentTypeValue, forHTTPHeaderField: Constants.Header.contentTypeKey)
        urlRequest.addValue(
            "\(Constants.Header.authorizationKeyType) \(token)",
            forHTTPHeaderField: Constants.Header.authorizationKey
        )
        
        if let body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw ApiError(errorCode: 0, message: "Error encoding http body")
            }
        }
        return urlRequest
    }
}

