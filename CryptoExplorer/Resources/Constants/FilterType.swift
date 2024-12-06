//
//  FilterType.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation

enum FilterType {
    case activeCoins
    case inactiveCoins
    case onlyTokens
    case onlyCoins
    case newCoins

    var title: String {
        switch self {
        case .activeCoins: return "Active Coins"
        case .inactiveCoins: return "Inactive Coins"
        case .onlyTokens: return "Only Tokens"
        case .onlyCoins: return "Only Coins"
        case .newCoins: return "New Coins"
        }
    }

    // Action closure that takes viewModel as a parameter
    var action: (Bool, CryptoViewModel) -> Void {
        switch self {
        case .activeCoins:
            return { isSelected, viewModel in
                viewModel.filterCoins(isActive: isSelected ? true : nil)
            }
        case .inactiveCoins:
            return { isSelected, viewModel in
                viewModel.filterCoins(isActive: isSelected ? false : nil)
            }
        case .onlyTokens:
            return { isSelected, viewModel in
                viewModel.filterCoins(type: isSelected ? "token" : nil)
            }
        case .onlyCoins:
            return { isSelected, viewModel in
                viewModel.filterCoins(type: isSelected ? "coin" : nil)
            }
        case .newCoins:
            return { isSelected, viewModel in
                viewModel.filterCoins(isNew: isSelected ? true : nil)
            }
        }
    }
}

extension FilterType {
    // Initialize a FilterType from a title string
    init?(title: String) {
        switch title {
        case "Active Coins":
            self = .activeCoins
        case "Inactive Coins":
            self = .inactiveCoins
        case "Only Tokens":
            self = .onlyTokens
        case "Only Coins":
            self = .onlyCoins
        case "New Coins":
            self = .newCoins
        default:
            return nil
        }
    }
}
