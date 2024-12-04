//
//  NetworkManager.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 03/12/24.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void) {
        let urlString = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let coins = try JSONDecoder().decode([CryptoCoin].self, from: data)
                completion(.success(coins))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
