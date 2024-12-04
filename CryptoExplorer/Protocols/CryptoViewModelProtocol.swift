//
//  CryptoViewModelProtocol.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation

/// A protocol for the `CryptoViewModel` to expose essential methods and properties
protocol CryptoViewModelProtocol {
    /// A list of filtered coins based on search and filter criteria
    var filteredCoins: [CryptoCoin] { get }

    /// A callback that is triggered when the data is updated (filtered or fetched)
    var onDataUpdated: (() -> Void)? { get set }

    /// Fetches cryptocurrency data and updates the `filteredCoins` list
    func fetchCryptoCoins()

    /// Filters coins based on optional parameters for active status, newness, and type
    /// - Parameters:
    ///   - isActive: Optional filter for active/inactive coins
    ///   - isNew: Optional filter for new coins
    ///   - type: Optional filter for coin type
    func filterCoins(isActive: Bool?, isNew: Bool?, type: String?)

    /// Searches for coins by name or symbol based on the provided query string
    /// - Parameter query: The search query string for coin names or symbols
    func searchCoins(query: String)
}
