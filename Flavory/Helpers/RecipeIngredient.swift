//
//  RecipeIngredient.swift
//  Flavory
//
//  Created by Ivan Stoilov on 11.10.21.
//

import Foundation

class RecipeIngredient: Codable {
    let name: String
    let original: String
    private let image: String?
    var imageURL: String {
        get {
            return ("https://spoonacular.com/cdn/ingredients_250x250/\(image ?? "asdasdasd")")
        }
    }
    private enum CodingKeys: String, CodingKey {
        
        case name
        case original
        case image
        
    }
}
