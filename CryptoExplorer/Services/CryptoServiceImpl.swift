//
//  CryptoServiceImpl.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 04/12/24.
//

import Foundation

/// Implementation of the `CryptoService` protocol, responsible for fetching cryptocurrency data.
class CryptoServiceImpl: CryptoService {

    private let networkManager: Networking  // The network manager to handle network requests

    /// Initializes the service with a specified network manager.
    /// - Parameter networkManager: The networking instance to use. Defaults to `URLSessionNetworkManager`.
    init(networkManager: Networking = URLSessionNetworkManager()) {
        self.networkManager = networkManager
    }

    /// Fetches cryptocurrency data from the specified base URL.
    /// - Parameters:
    ///   - baseURL: The base URL for the network request (unused here, but can be passed for future flexibility).
    ///   - completion: A closure that handles the result (success or failure).
    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void) {

        // Construct the full URL using NetworkConfig, passing the empty path as an example.
        guard let url = NetworkConfig.makeURL(path: NetworkConfig.Endpoints.empty) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        networkManager.fetch(url: url, entityName: "CryptoCoinEntity", completion: completion)
    }
}

