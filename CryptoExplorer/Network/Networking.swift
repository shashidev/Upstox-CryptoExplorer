//
//  Networking.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 04/12/24.
//

import Foundation

/// Protocol for network operations.
protocol Networking {

    /// Fetches data from a given URL and decodes it into a specified type.
    /// - Parameters:
    ///   - url: The URL to fetch data from.
    ///   - completion: A closure that returns either a decoded result or an error.
    func fetch<T: Codable>(url: URL, entityName: String, completion: @escaping (Result<T, Error>) -> Void)
}

