//
//  RecipeModel+CoreDataProperties.swift
//  Flavory
//
//  Created by Ivan Stoilov on 1.11.21.
//
//

import Foundation
import CoreData


extension RecipeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeModel> {
        return NSFetchRequest<RecipeModel>(entityName: "RecipeModel")
    }

    @NSManaged public var id: Int
    @NSManaged public var imageURL: String?
    @NSManaged public var isInProgress: Bool
    @NSManaged public var preparationTime: Int
    @NSManaged public var price: Double
    @NSManaged public var progress: Int
    @NSManaged public var servings: Int
    @NSManaged public var title: String?
    @NSManaged public var detail: Detail?
    @NSManaged public var ingredient: [Ingredient]?
    @NSManaged public var step: [Step]?
    @NSManaged public var origin: DailyMenu?

}

// MARK: Generated accessors for ingredient
extension RecipeModel {

    @objc(insertObject:inIngredientAtIndex:)
    @NSManaged public func insertIntoIngredient(_ value: Ingredient, at idx: Int)

    @objc(removeObjectFromIngredientAtIndex:)
    @NSManaged public func removeFromIngredient(at idx: Int)

    @objc(insertIngredient:atIndexes:)
    @NSManaged public func insertIntoIngredient(_ values: [Ingredient], at indexes: NSIndexSet)

    @objc(removeIngredientAtIndexes:)
    @NSManaged public func removeFromIngredient(at indexes: NSIndexSet)

    @objc(replaceObjectInIngredientAtIndex:withObject:)
    @NSManaged public func replaceIngredient(at idx: Int, with value: Ingredient)

    @objc(replaceIngredientAtIndexes:withIngredient:)
    @NSManaged public func replaceIngredient(at indexes: NSIndexSet, with values: [Ingredient])

    @objc(addIngredientObject:)
    @NSManaged public func addToIngredient(_ value: Ingredient)

    @objc(removeIngredientObject:)
    @NSManaged public func removeFromIngredient(_ value: Ingredient)

    @objc(addIngredient:)
    @NSManaged public func addToIngredient(_ values: NSOrderedSet)

    @objc(removeIngredient:)
    @NSManaged public func removeFromIngredient(_ values: NSOrderedSet)

}

// MARK: Generated accessors for step
extension RecipeModel {

    @objc(insertObject:inStepAtIndex:)
    @NSManaged public func insertIntoStep(_ value: Step, at idx: Int)

    @objc(removeObjectFromStepAtIndex:)
    @NSManaged public func removeFromStep(at idx: Int)

    @objc(insertStep:atIndexes:)
    @NSManaged public func insertIntoStep(_ values: [Step], at indexes: NSIndexSet)

    @objc(removeStepAtIndexes:)
    @NSManaged public func removeFromStep(at indexes: NSIndexSet)

    @objc(replaceObjectInStepAtIndex:withObject:)
    @NSManaged public func replaceStep(at idx: Int, with value: Step)

    @objc(replaceStepAtIndexes:withStep:)
    @NSManaged public func replaceStep(at indexes: NSIndexSet, with values: [Step])

    @objc(addStepObject:)
    @NSManaged public func addToStep(_ value: Step)

    @objc(removeStepObject:)
    @NSManaged public func removeFromStep(_ value: Step)

    @objc(addStep:)
    @NSManaged public func addToStep(_ values: NSOrderedSet)

    @objc(removeStep:)
    @NSManaged public func removeFromStep(_ values: NSOrderedSet)

}

extension RecipeModel : Identifiable {

}
