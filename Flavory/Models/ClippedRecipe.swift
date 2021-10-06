//
//  ClippedRecipe.swift
//  Flavory
//
//  Created by Ivan Stoilov on 27.09.21.
//

import Foundation

class ClippedRecipe: Codable {
    
    let recipeDetails: RecipeDetails
    
    var imageURL: String {
        get {
        return "https://spoonacular.com/recipeImages/\(id)-636x393.jpg"
        }
    }
    
    var recipePrice: Double {
        //if let pricePerServing = pricePerServing{
        //    if let servings = servings{
        //        return Double((Int(pricePerServing) * servings) / 100)
        //    }
        //}
        
        return 0.0
    }
    var title: String = ""
    var id: Int = 0
    var readyInMinutes: Int?
    var pricePerServing: Int?
    var servings: Int?
    var summary: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case id
        case readyInMinutes
        case servings
        case summary
        case pricePerServing
    }
    
    required init(from decoder:Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        id = try values.decode(Int.self, forKey: .id)
        readyInMinutes = try values.decode(Int.self, forKey: .readyInMinutes)
        servings = try values.decode(Int.self, forKey: .servings)
        summary = try values.decode(String.self, forKey: .summary)
        recipeDetails = RecipeDetails()
        
        if let summary = summary{
            recipeDetails.loadData(recipeSumary: summary)
        }
    }
}
