//
//  NetworkManager.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 03/12/24.
//

import Foundation

/// A class that conforms to the `Networking` protocol, responsible for performing network requests using `URLSession`.
class URLSessionNetworkManager: Networking {

    private var session: URLSession  // URLSession instance to manage the network requests

    /// Initializes the network manager with a custom `URLSessionConfiguration`. Defaults to `.default`.
    /// - Parameter configuration: Custom configuration for the session.
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }

    /// Fetches data from the specified URL, decodes it to the specified type, and returns the result.
    /// - Parameters:
    ///   - url: The URL from which to fetch data.
    ///   - completion: A closure that is called with the decoded result or an error.
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {

            let task = self.session.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        return completion(.failure(error))
                    }

                    guard let data = data else {
                        return completion(.failure(NetworkError.noData))
                    }

                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
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


