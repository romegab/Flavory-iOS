//
//  Detail+CoreDataProperties.swift
//  Flavory
//
//  Created by Ivan Stoilov on 15.10.21.
//
//

import Foundation
import CoreData


extension Detail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail> {
        return NSFetchRequest<Detail>(entityName: "Detail")
    }

    @NSManaged public var calories: Int
    @NSManaged public var protein: Int
    @NSManaged public var fat: Int
    @NSManaged public var recipeDescription: String?
    @NSManaged public var origin: RecipeModel?

}

extension Detail : Identifiable {

}
