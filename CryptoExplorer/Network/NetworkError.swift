//
//  NetworkError.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 04/12/24.
//

import Foundation

/// Enum representing different types of network errors.
enum NetworkError: Error {

    /// Error when the URL is invalid or malformed.
    case invalidURL

    /// Error when no data is received from the network request.
    case noData

    /// Error when there is a failure while decoding the response data.
    case decodingError
}

