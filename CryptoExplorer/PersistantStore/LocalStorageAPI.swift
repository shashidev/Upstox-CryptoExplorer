//
//  LocalStorageAPI.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation
import CoreData


enum CoreDataError: Error {
    case saveFailed
    case fetchFailed
    case deleteFailed
    case noEntityFound
}

class LocalStorageAPI: CoreDataService {

    private var coredataStack: CoreDataStack

    init(coredataStack: CoreDataStack = .shared) {
        self.coredataStack = coredataStack
    }


    func save<T: Codable>(object: T, entityName: String, completion: @escaping (Result<Void, Error>) -> Void) {

        let context = coredataStack.viewContext

        context.perform {
            do {
                // Fetch existing object or create a new one
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

                let results = try context.fetch(fetchRequest)
                let entity = results.first ?? NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)

                entity.setValue(object, forKey: "coins")

                // Save the context
                self.coredataStack.saveData(context: context)
                completion(.success(()))
            } catch {
                completion(.failure(CoreDataError.saveFailed))
            }
        }

    }

    func fetch<T>(entityName: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {

        let context = coredataStack.viewContext

        context.perform {
            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

                guard let result = try context.fetch(fetchRequest).first, let data = result.value(forKey: "coins") as? T else {
                    throw CoreDataError.noEntityFound
                }
                completion(.success(data))

            } catch {
                completion(.failure(CoreDataError.fetchFailed))
            }
        }

    }

    func delete(entityName: String, completion: @escaping (Result<Void, Error>) -> Void) {

        let context = coredataStack.viewContext

        context.perform {
            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

                let results = try context.fetch(fetchRequest)
                for object in results {
                    context.delete(object)
                }

                // Save the context
                self.coredataStack.saveData(context: context)
                completion(.success(()))
            } catch {
                completion(.failure(CoreDataError.deleteFailed))
            }
        }
    }


}
