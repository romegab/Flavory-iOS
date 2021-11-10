import Foundation

class IngredientResultArray: Codable {
    let results: [RecipeIngredient]?
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}
