//
//  FilterUnion.swift
//  Flavory
//
//  Created by Ivan Stoilov on 8.11.21.
//

import Foundation

struct FilterUnion {
    let minCarbs: Int
    let maxCarbs: Int
    
    let minProtein: Int
    let maxProtein: Int
    
    let minCalories: Int
    let maxCalories: Int
    
    let minFat: Int
    let maxFat: Int
    
    let cousine: String
    let mealType: String
    
    var ingredients: [RecipeIngredient]?
    
    init (_ minCarbs: Int, _ maxCarbs: Int, _ minProtein: Int, _ maxProtein: Int, _ minCalories: Int, _ maxCalories: Int, _ minFat: Int, _ maxFat: Int, _ cousine: String, _ mealType: String, _ ingredients: [RecipeIngredient]?) {
        self.minCarbs = minCarbs
        self.maxCarbs = maxCarbs
        self.minFat = minFat
        self.maxFat = maxFat
        self.minCalories = minCalories
        self.maxCalories = maxCalories
        self.minProtein = minProtein
        self.maxProtein = maxProtein
        self.cousine = cousine
        self.mealType = mealType
        self.ingredients = ingredients
    }
}
