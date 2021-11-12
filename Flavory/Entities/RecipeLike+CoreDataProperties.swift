//
//  RecipeLike+CoreDataProperties.swift
//  Flavory
//
//  Created by Ivan Stoilov on 12.11.21.
//
//

import Foundation
import CoreData


extension RecipeLike {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeLike> {
        return NSFetchRequest<RecipeLike>(entityName: "RecipeLike")
    }

    @NSManaged public var id: Int

}

extension RecipeLike : Identifiable {

}
