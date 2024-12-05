//
//  LocalStorageAPI.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation
import CoreData


/// A class that provides a Core Data-based implementation of the `CoreDataService` protocol.
/// Handles saving, fetching, and deleting data in the Core Data persistent store.
class LocalStorageAPI: CoreDataService {

    /// The Core Data stack used for managing the Core Data context and persistent container.
    private var coredataStack: CoreDataStack

    /// Initializes the LocalStorageAPI with a specific CoreDataStack.
    /// - Parameter coredataStack: The CoreDataStack instance. Defaults to the shared instance.
    init(coredataStack: CoreDataStack = .shared) {
        self.coredataStack = coredataStack
    }

    /// Saves a codable object to Core Data under the specified entity name.
    /// - Parameters:
    ///   - object: The object to be saved, which must conform to `Codable`.
    ///   - entityName: The name of the Core Data entity where the object will be stored.
    ///   - completion: A closure that is called when the save operation completes.
    ///                 On success, the closure returns `Void`.
    ///                 On failure, the closure returns an error.
    func save<T: Codable>(object: T, entityName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coredataStack.viewContext

        context.perform {
            do {
                // Step 1: Delete existing data to maintain a single object per entity.
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
                let results = try context.fetch(fetchRequest)
                for object in results {
                    context.delete(object)
                }

                // Step 2: Encode the object into Data.
                let encodedData = try JSONEncoder().encode(object)

                // Step 3: Insert a new entity and save the encoded data.
                let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
                entity.setValue(encodedData, forKey: "coins")

                // Step 4: Save the context.
                self.coredataStack.saveData(context: context)
                completion(.success(()))
            } catch {
                completion(.failure(CoreDataError.saveFailed))
            }
        }
    }

    /// Fetches data from Core Data and decodes it into the specified type.
    /// - Parameters:
    ///   - entityName: The name of the Core Data entity to fetch data from.
    ///   - type: The type to which the fetched data will be decoded. Must conform to `Codable`.
    ///   - completion: A closure that is called when the fetch operation completes.
    ///                 On success, the closure returns the decoded object.
    ///                 On failure, the closure returns an error.
    func fetch<T: Codable>(entityName: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let context = coredataStack.viewContext

        context.perform {
            do {
                // Step 1: Fetch the first object from the specified entity.
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
                guard let result = try context.fetch(fetchRequest).first else {
                    throw CoreDataError.noEntityFound
                }

                // Step 2: Extract the data from the transformable attribute.
                guard let data = result.value(forKey: "coins") as? Data else {
                    throw CoreDataError.noEntityFound
                }

                // Step 3: Decode the data into the specified type.
                let decodedData = try JSONDecoder().decode(T.self, from: data)

                // Return the decoded data.
                completion(.success(decodedData))
            } catch {
                completion(.failure(CoreDataError.fetchFailed))
            }
        }
    }

    /// Deletes all objects in the specified Core Data entity.
    /// - Parameters:
    ///   - entityName: The name of the Core Data entity to delete all objects from.
    ///   - completion: A closure that is called when the delete operation completes.
    ///                 On success, the closure returns `Void`.
    ///                 On failure, the closure returns an error.
    func delete(entityName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coredataStack.viewContext

        context.perform {
            do {
                // Step 1: Fetch all objects in the specified entity.
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
                let results = try context.fetch(fetchRequest)

                // Step 2: Delete each object.
                for object in results {
                    context.delete(object)
                }

                // Step 3: Save the context.
                self.coredataStack.saveData(context: context)
                completion(.success(()))
            } catch {
                completion(.failure(CoreDataError.deleteFailed))
            }
        }
    }
}

