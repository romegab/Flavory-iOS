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
    var title: String = ""
    var id: Int = 0
    var readyInMinutes: Int?
    var servings: Int?
    var summary: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case id
        case readyInMinutes
        case servings
        case summary
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
