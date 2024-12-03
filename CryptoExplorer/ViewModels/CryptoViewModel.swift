//
//  CryptoViewModel.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 03/12/24.
//

import Foundation


class CryptoViewModel {
    private var allCoins: [CryptoCoin] = []
    var filteredCoins: [CryptoCoin] = []

    var onDataUpdated: (() -> Void)?

    func fetchCryptoCoins() {
        NetworkManager.shared.fetchCryptoCoins { [weak self] result in
            switch result {
            case .success(let coins):
                self?.allCoins = coins
                self?.filteredCoins = coins
                self?.onDataUpdated?()
            case .failure(let error):
                print("Error fetching coins: \(error)")
            }
        }
    }

    func filterCoins(isActive: Bool? = nil, isNew: Bool? = nil, type: String? = nil) {
        filteredCoins = allCoins.filter { coin in
            let matchesActive = isActive == nil || coin.isActive == isActive
            let matchesNew = isNew == nil || coin.isNew == isNew
            let matchesType = type == nil || coin.type == type
            return matchesActive && matchesNew && matchesType
        }
        onDataUpdated?()
    }

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
