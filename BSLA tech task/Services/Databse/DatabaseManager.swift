//
//  DatabaseManager.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/1/24.
//

import Foundation
import CoreData

final class RecepieDBManager {
    // MARK: - properties
    static let context = RecepieDBCoreDataStack.shared.viewContext
}

// MARK: - logics
extension RecepieDBManager {
    static func storeRecepies(data recepies: [RRecepieItemModel]) {
        for recepy in recepies {
            let item = RecepieEntity(context: context)
            item.id = Int16(recepy.id)
            item.title = recepy.title
            item.imageUrl = recepy.image
            item.info = recepy.title
        }
        RecepieDBCoreDataStack.shared.saveContext()
    }
    
    static func fetchRecepies() -> [RecepieEntity] {
        let fetchRequest: NSFetchRequest<RecepieEntity> = RecepieEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error.localizedDescription)")
            return []
        }
    }
    
    static func bookmark(id: Int) {
        if let item = fetchItem(with: id) {
            item.bookmarked.toggle()
            RecepieDBCoreDataStack.shared.saveContext()
        }
    }
    
    static func fetchItem(with id: Int) -> RecepieEntity? {
        let fetchRequest: NSFetchRequest<RecepieEntity> = RecepieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching item: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func fetchBookmarked() -> [RecepieEntity] {
        let fetchRequest: NSFetchRequest<RecepieEntity> = RecepieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookmarked == true")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching item: \(error.localizedDescription)")
            return []
        }
    }
}
