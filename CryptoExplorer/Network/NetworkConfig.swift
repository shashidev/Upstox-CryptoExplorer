//
//  NetworkConfig.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 04/12/24.
//

import Foundation

/// A structure to hold the base URL and endpoints for network requests.
struct NetworkConfig {

    /// The base URL for the API.
    static let baseURL = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io"

    /// A nested struct that holds all available endpoints.
    struct Endpoints {
        static let empty = ""
        static let cryptoCoins = "/crypto-coins"
        // Add more endpoints here as needed
    }

    /// Constructs a full URL from the base URL, a specific path, and optional query parameters.
    /// - Parameters:
    ///   - path: The path to append to the base URL (e.g., `/crypto-coins`).
    ///   - queryItems: Optional query parameters to add to the URL.
    /// - Returns: A complete URL or `nil` if construction fails.
    static func makeURL(path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path += path
        components?.queryItems = queryItems
        return components?.url
    }
}

