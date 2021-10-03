//
//  ClippedRecipe.swift
//  Flavory
//
//  Created by Ivan Stoilov on 27.09.21.
//

import Foundation

class ClippedRecipe: Codable {
    var imageURL: String {
        get {
        return "https://spoonacular.com/recipeImages/\(id)-636x393.jpg"
        }
    }
    var title: String = ""
    var id: Int = 0
    var readyInMinutes: Int?
    var servings: Int?
}
