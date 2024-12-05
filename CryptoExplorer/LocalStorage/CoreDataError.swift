//
//  CoreDataError.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 06/12/24.
//

import Foundation

/// An enumeration representing common errors encountered in Core Data operations.
enum CoreDataError: Error, LocalizedError {
    /// Indicates that saving data to Core Data has failed.
    case saveFailed

    /// Indicates that fetching data from Core Data has failed.
    case fetchFailed

    /// Indicates that deleting data from Core Data has failed.
    case deleteFailed

    /// Indicates that no matching entity was found in Core Data.
    case noEntityFound

    /// Provides a user-friendly description for each error.
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save data to the persistent store."
        case .fetchFailed:
            return "Failed to fetch data from the persistent store."
        case .deleteFailed:
            return "Failed to delete data from the persistent store."
        case .noEntityFound:
            return "No matching entity was found in the persistent store."
        }
    }
}

