//
//  ApiClient.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import Foundation

protocol ApiClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint) async throws -> T
}

extension ApiClient {
    
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = Constants.API.timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = Constants.API.timeoutIntervalForResource
        return URLSession(configuration: configuration)
    }
    
    func sendRequest<T: Decodable>(endpoint: Endpoint) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.asURLRequest())
            return try self.manageResponse(data: data, response: response)
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError(errorCode: 0, message: "Unknown API error \(error.localizedDescription)")
        }
    }
    
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw ApiError(errorCode: 0, message: "Invalid HTTP response")
        }
        switch response.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("‼️", error)
                throw ApiError(errorCode: 0, message: "Error decoding data")
            }
        default:
            guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: 0,
                    message: "Unknown backend error"
                )
            }

            throw ApiError(
                statusCode: response.statusCode,
                errorCode: decodedError.errorCode,
                message: decodedError.message,
                success: decodedError.success
            )
        }
    }
}
