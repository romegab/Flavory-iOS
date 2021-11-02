//
//  MenuNutrients.swift
//  Flavory
//
//  Created by Ivan Stoilov on 1.11.21.
//

import Foundation
class MenuNutrients: Codable {
    
    var calories: Double?
    var protein: Double?
    var fat: Double?
    var carbohydrates: Double?
    
    private enum CodingKeys: String, CodingKey {
        case calories
        case protein
        case fat
        case carbohydrates
    }
}
