//
//  Ingredient+CoreDataProperties.swift
//  Flavory
//
//  Created by Ivan Stoilov on 25.10.21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var id: Int
    @NSManaged public var image: String?
    @NSManaged public var ingredientDescription: String?
    @NSManaged public var isChecked: Bool
    @NSManaged public var name: String?
    @NSManaged public var origin: RecipeModel?

}

extension Ingredient : Identifiable {

}
