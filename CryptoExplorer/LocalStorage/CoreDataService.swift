//
//  CoreDataService.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation


/// Protocol defining a service interface for managing Core Data operations.
/// Provides methods to save, fetch, and delete data from the persistent store.
protocol CoreDataService {

    /// Saves a codable object to the specified Core Data entity.
    /// - Parameters:
    ///   - object: The object to be saved, which must conform to `Codable`.
    ///   - entityName: The name of the Core Data entity where the object will be stored.
    ///   - completion: A closure that is called when the save operation is completed.
    ///                 On success, the closure returns `Void`.
    ///                 On failure, the closure provides an error indicating the failure reason.
    func save<T: Codable>(object: T, entityName: String, completion: @escaping (Result<Void, Error>) -> Void)

    /// Fetches data from the specified Core Data entity and decodes it into the specified type.
    /// - Parameters:
    ///   - entityName: The name of the Core Data entity from which to fetch data.
    ///   - type: The type of object to decode the fetched data into. Must conform to `Codable`.
    ///   - completion: A closure that is called when the fetch operation is completed.
    ///                 On success, the closure returns the decoded object.
    ///                 On failure, the closure provides an error indicating the failure reason.
    func fetch<T: Codable>(entityName: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void)

    /// Deletes all objects from the specified Core Data entity.
    /// - Parameters:
    ///   - entityName: The name of the Core Data entity from which to delete all objects.
    ///   - completion: A closure that is called when the delete operation is completed.
    ///                 On success, the closure returns `Void`.
    ///                 On failure, the closure provides an error indicating the failure reason.
    func delete(entityName: String, completion: @escaping (Result<Void, Error>) -> Void)
}

