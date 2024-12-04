//
//  CryptoService.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 04/12/24.
//

import Foundation

/// Protocol defining the service to fetch cryptocurrency data.
protocol CryptoService {

    /// Fetches cryptocurrency data and returns the result via a completion handler.
    /// - Parameter completion: A closure that returns either a list of `CryptoCoin` objects on success, or an `Error` on failure.
    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void)
}

