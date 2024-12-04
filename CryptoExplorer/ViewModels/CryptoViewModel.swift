//
//  CryptoViewModel.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 03/12/24.
//

import Foundation

/// A concrete implementation of `CryptoViewModelProtocol` that handles cryptocurrency data
class CryptoViewModel: CryptoViewModelProtocol {

    /// The service responsible for fetching cryptocurrency data
    private var cryptoService: CryptoService

    /// A list of all fetched coins, unfiltered
    private var allCoins: [CryptoCoin] = []

    /// A list of currently visible, filtered coins
    var filteredCoins: [CryptoCoin] = []

    /// A callback that gets triggered when the data is updated (e.g., after fetching or filtering)
    var onDataUpdated: (() -> Void)?

    var onError: (() -> Void)?

    /// Initializes the view model with an optional crypto service. Defaults to `CryptoServiceImpl`.
    /// - Parameter cryptoService: The service used to fetch cryptocurrency data.
    init(cryptoService: CryptoService = CryptoServiceImpl()) {
        self.cryptoService = cryptoService
    }

    /// Fetches cryptocurrency data and updates the `filteredCoins` list.
    func fetchCryptoCoins() {
        cryptoService.fetchCryptoCoins { [weak self] result in
            switch result {
            case .success(let coins):
                self?.allCoins = coins
                self?.filteredCoins = coins
                self?.onDataUpdated?()
            case .failure(let error):
                print("Error fetching coins: \(error)")
                self?.onError?()
            }
        }
    }

    /// Filters coins based on the provided criteria.
    /// - Parameters:
    ///   - isActive: Optional filter for active/inactive status.
    ///   - isNew: Optional filter for new coins.
    ///   - type: Optional filter for coin type.
    func filterCoins(isActive: Bool? = nil, isNew: Bool? = nil, type: String? = nil) {
        filteredCoins = allCoins.filter { coin in
            let matchesActive = isActive == nil || coin.isActive == isActive
            let matchesNew = isNew == nil || coin.isNew == isNew
            let matchesType = type == nil || coin.type == type
            return matchesActive && matchesNew && matchesType
        }
        onDataUpdated?()
    }

    /// Searches for coins by name or symbol.
    /// - Parameter query: The search query string.
    func searchCoins(query: String) {
        if query.isEmpty {
            filteredCoins = allCoins
        } else {
            filteredCoins = allCoins.filter { coin in
                coin.name.lowercased().contains(query.lowercased()) ||
                coin.symbol.lowercased().contains(query.lowercased())
            }
        }
        onDataUpdated?()
    }
}
