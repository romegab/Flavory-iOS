//
//  RecipeIngredient.swift
//  Flavory
//
//  Created by Ivan Stoilov on 11.10.21.
//

import Foundation

struct RecipeIngredient: Codable {
    let id: Int?
    let name: String?
    let original: String?
    var isChecked: Bool = false
    private let image: String?
    var imageURL: String {
        get {
            return ("https://spoonacular.com/cdn/ingredients_250x250/\(image ?? "asdasdasd")")
        }
    }
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case original
        case image
        
    }
}
