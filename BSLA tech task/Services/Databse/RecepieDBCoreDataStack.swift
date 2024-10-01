//
//  DatabaseManager.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/1/24.
//

import Foundation
import CoreData

class RecepieDBCoreDataStack: NSObject, ObservableObject {
    // MARK: - singleton reference
    static let shared = RecepieDBCoreDataStack()

    // MARK: - properties
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecepieDB")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
