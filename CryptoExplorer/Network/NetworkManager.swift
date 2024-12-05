//
//  NetworkManager.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 03/12/24.
//

import Foundation

/// A class that conforms to the `Networking` protocol, responsible for performing network requests using `URLSession`.
class URLSessionNetworkManager: Networking {

    private var session: URLSession
    private var localStorageApi: CoreDataService
    private let reachability: ReachabilityProtocol

    /// Initializes the network manager with a custom `URLSessionConfiguration`. Defaults to `.default`.
    /// - Parameter configuration: Custom configuration for the session.
    init(configuration: URLSessionConfiguration = .default,
         localStorageApi: CoreDataService = LocalStorageAPI(),
         reachability: ReachabilityProtocol = NetworkReachability.shared) {
        self.session = URLSession(configuration: configuration)
        self.localStorageApi = localStorageApi
        self.reachability = reachability
    }

    /// Fetches data from the specified URL and decodes it to the specified type.
    /// If the network is unavailable or a network error occurs, it attempts to retrieve data from local storage.
    /// If data is successfully fetched from the network, it is also saved to local storage for offline access.
    /// - Parameters:
    ///   - url: The URL from which to fetch data.
    ///   - entityName: The name of the Core Data entity used for local storage.
    ///   - completion: A closure that is called with the decoded result or an error.
    ///                On success, the closure provides the decoded object of the specified type.
    ///                On failure, the closure provides an error indicating the failure reason.
    func fetch<T: Codable>(url: URL, entityName: String, completion: @escaping (Result<T, Error>) -> Void) {

        if !reachability.isReachable() {
            return self.localStorageApi.fetch(entityName: entityName, as: T.self, completion: completion)
        }

        DispatchQueue.global(qos: .background).async {

            let task = self.session.dataTask(with: url) { [weak self] data, response, error in

                guard let self = self else { return }

                DispatchQueue.main.async {
                    if let _ = error {
                        return self.localStorageApi.fetch(entityName: entityName, as: T.self, completion: completion)
                    }

                    guard let data = data else {
                        return self.localStorageApi.fetch(entityName: entityName, as: T.self, completion: completion)
                    }

                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)

                        self.localStorageApi.save(object: decodedData, entityName: entityName) { saveResult in
                            if case .failure(let error) = saveResult {
                                print("Failed to save data locally: \(error)")
                            }
                        }
                        completion(.success(decodedData))

                    } catch {
                        completion(.failure(NetworkError.decodingError))
                    }
                }

            }
            task.resume()
        }
    }
}


