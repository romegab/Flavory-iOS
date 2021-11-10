//
//  RecipeIngredient.swift
//  Flavory
//
//  Created by Ivan Stoilov on 11.10.21.
//

import Foundation

class RecipeIngredient: Codable {
    
    let id: Int?
    let name: String?
    let original: String?
    var isChecked: Bool = false
    var image: String?
    
    var imageURL: String {
        get {
            return "https://spoonacular.com/cdn/ingredients_250x250/\(image ?? "nilValue")"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case original
        case image
    }
    
    init (from ingredient: Ingredient) {
        self.id = ingredient.id
        self.name = ingredient.name
        self.original = ingredient.ingredientDescription
        self.isChecked = ingredient.isChecked
        self.image = ingredient.image
    }
    
}
