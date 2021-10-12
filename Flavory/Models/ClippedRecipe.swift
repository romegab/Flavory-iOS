//
//  ClippedRecipe.swift
//  Flavory
//
//  Created by Ivan Stoilov on 27.09.21.
//

import Foundation

class ClippedRecipe: Codable {
    
    lazy var recipeDetails: RecipeDetails = {
        let details = RecipeDetails()
        
        if let summary = summary {
            details.loadData(recipeSumary: summary)
        }
        return details
    }()
    
    var imageURL: String {
        get {
        return "https://spoonacular.com/recipeImages/\(id)-636x393.jpg"
        }
    }
    
    var recipePrice: Double{
        get{
            if let pricePerServing = pricePerServing{
                if let servings = servings{
                    return Double((Int(pricePerServing) * servings) / 100)
                }
            }
            
            return 0.0
        }
    }
    let title: String
    let id: Int
    let readyInMinutes: Int?
    let pricePerServing: Double?
    let servings: Int?
    private var summary: String?
    private var extendedIngredients: [RecipeIngredient]?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case id
        case readyInMinutes
        case servings
        case summary
        case pricePerServing
        case extendedIngredients
    }
}
