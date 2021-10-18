//
//  RecipeModel+CoreDataProperties.swift
//  Flavory
//
//  Created by Ivan Stoilov on 15.10.21.
//
//

import Foundation
import CoreData


extension RecipeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeModel> {
        return NSFetchRequest<RecipeModel>(entityName: "RecipeModel")
    }
    @NSManaged public var id: Int
    @NSManaged public var title: String?
    @NSManaged public var preparationTime: Int
    @NSManaged public var price: Double
    @NSManaged public var servings: Int
    @NSManaged public var detail: Detail?
    @NSManaged public var ingredient: NSSet?
    @NSManaged public var step: NSSet?

}

// MARK: Generated accessors for ingredient
extension RecipeModel {

    @objc(addIngredientObject:)
    @NSManaged public func addToIngredient(_ value: Ingredient)

    @objc(removeIngredientObject:)
    @NSManaged public func removeFromIngredient(_ value: Ingredient)

    @objc(addIngredient:)
    @NSManaged public func addToIngredient(_ values: NSSet)

    @objc(removeIngredient:)
    @NSManaged public func removeFromIngredient(_ values: NSSet)

}

// MARK: Generated accessors for step
extension RecipeModel {

    @objc(addStepObject:)
    @NSManaged public func addToStep(_ value: Step)

    @objc(removeStepObject:)
    @NSManaged public func removeFromStep(_ value: Step)

    @objc(addStep:)
    @NSManaged public func addToStep(_ values: NSSet)

    @objc(removeStep:)
    @NSManaged public func removeFromStep(_ values: NSSet)

}

extension RecipeModel : Identifiable {

}
