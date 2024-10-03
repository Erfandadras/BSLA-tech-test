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
        for recipe in recepies {
            let item = RecepieEntity(context: context)
            item.id = Int32(recipe.id)
            item.title = recipe.title
            item.imageUrl = recipe.image
            item.info = recipe.title
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
    
    static func bookmark(id: Int) -> RecepieEntity? {
        if let item = fetchItem(with: id) {
            item.bookmarked.toggle()
            RecepieDBCoreDataStack.shared.saveContext()
            return item
        } else {
            return nil
        }
    }
    
    static func fetchItem(with id: Int) -> RecepieEntity? {
        let fetchRequest: NSFetchRequest<RecepieEntity> = RecepieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
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
    
    static func clearDB() {
        for item in fetchRecepies() {
            context.delete(item)
            RecepieDBCoreDataStack.shared.saveContext()
        }
    }
}
