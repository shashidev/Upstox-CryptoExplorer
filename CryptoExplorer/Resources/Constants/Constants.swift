//
//  Constants.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation

struct Constants {

    struct Titles {
        static let firstRowTitles = [FilterType.activeCoins.title, FilterType.inactiveCoins.title, FilterType.onlyTokens.title]
        static let secondRowTitles = [FilterType.onlyCoins.title, FilterType.newCoins.title]
    }

    struct ErrorMessages {
        static let emptyStateMessage = "No data available."
    }

    struct ViewControllerTitles {
        static let cryptoCoins = "Crypto Coins"
        static let searchBarPlaceholder = "Search by name or symbol"
    }

    struct CoinType {
        static let coin = "coin"
        static let token = "token"
    }

    // Add any other constants for your project here


}

