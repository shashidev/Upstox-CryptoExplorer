//
//  CoreDataStack.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    private init() { }

    private lazy var persistentContainer: NSPersistentContainer = {


        let contrainer = NSPersistentContainer(name: "CryptoExplorer")

        contrainer.loadPersistentStores { storeDescriprion, error in
            print("Error ocured while loading presistant store: \(String(describing: error?.localizedDescription))")
        }

        return contrainer
    }()


    // ViewContext for main-thread operations
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // Background Context for background-thread operations
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    func saveData(context: NSManagedObjectContext? = nil) {
        let contextToSave = context ?? viewContext

        if contextToSave.hasChanges {
            do {
                try contextToSave.save()
            }catch let error {
                print("Error occured while saving data: \(String(describing: error.localizedDescription))" )
            }
        }
    }
}
