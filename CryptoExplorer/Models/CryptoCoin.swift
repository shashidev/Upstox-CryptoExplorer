//
//  CryptoCoin.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 03/12/24.
//

import Foundation

struct CryptoCoin: Codable {
    let name: String
    let symbol: String
    let type: String
    let isActive: Bool?  // Make 'isActive' optional to handle missing keys
    let isNew: Bool

    // Custom CodingKeys to match the JSON structure (if the keys in JSON differ)
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case type
        case isActive = "is_active" // If the JSON uses a different key, map it here
        case isNew = "is_new"
    }
}
