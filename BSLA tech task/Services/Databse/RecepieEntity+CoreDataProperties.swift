//
//  RecepieEntity+CoreDataProperties.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/1/24.
//
//

import Foundation
import CoreData


extension RecepieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecepieEntity> {
        return NSFetchRequest<RecepieEntity>(entityName: "RecepieEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var info: String?
    @NSManaged public var bookmarked: Bool
    @NSManaged public var imageUrl: URL?

}

extension RecepieEntity : Identifiable {

}
