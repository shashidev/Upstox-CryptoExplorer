//
//  CoreDataStack.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation
import CoreData

/// A class responsible for managing the Core Data stack.
/// Provides the Persistent Container and Core Data contexts for both main-thread and background-thread operations.
class CoreDataStack {

    /// Singleton instance of the CoreDataStack.
    static let shared = CoreDataStack()

    /// Private initializer to enforce the singleton pattern.
    private init() { }

    /// The persistent container responsible for loading the Core Data model and handling the persistent store.
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CryptoExplorer")

        // Load the persistent stores and handle errors during the load process.
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Error occurred while loading persistent store: \(error.localizedDescription)")
            }
        }

        return container
    }()

    /// Provides the main-thread context for Core Data operations tied to the UI.
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// Provides a background-thread context for Core Data operations to prevent UI blocking.
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    /// Saves changes in the specified context or the main context if none is provided.
    /// - Parameter context: The `NSManagedObjectContext` to save. Defaults to the main context (`viewContext`).
    func saveData(context: NSManagedObjectContext? = nil) {
        let contextToSave = context ?? viewContext

        guard contextToSave.hasChanges else { return }

        do {
            try contextToSave.save()
        } catch {
            print("Error occurred while saving data: \(error.localizedDescription)")
        }
    }
}
