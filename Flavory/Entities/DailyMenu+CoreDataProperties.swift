//
//  DailyMenu+CoreDataProperties.swift
//  Flavory
//
//  Created by Ivan Stoilov on 1.11.21.
//
//

import Foundation
import CoreData


extension DailyMenu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyMenu> {
        return NSFetchRequest<DailyMenu>(entityName: "DailyMenu")
    }

    @NSManaged public var date: String
    @NSManaged public var calories: Double
    @NSManaged public var fat: Double
    @NSManaged public var protein: Double
    @NSManaged public var carbohydrates: Double
    @NSManaged public var recipes: [RecipeModel]?

}

// MARK: Generated accessors for recipes
extension DailyMenu {

    @objc(addRecipesObject:)
    @NSManaged public func addToRecipes(_ value: RecipeModel)

    @objc(removeRecipesObject:)
    @NSManaged public func removeFromRecipes(_ value: RecipeModel)

    @objc(addRecipes:)
    @NSManaged public func addToRecipes(_ values: NSSet)

    @objc(removeRecipes:)
    @NSManaged public func removeFromRecipes(_ values: NSSet)

}

extension DailyMenu : Identifiable {

}
