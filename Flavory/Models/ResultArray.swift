//
//  ResultArray.swift
//  Flavory
//
//  Created by Ivan Stoilov on 27.09.21.
//

import Foundation

class ResultArray: Codable {
    //this array will be != nil if random search has been performed
    let recipes: [ClippedRecipe]?
    //this array will be != nil if query search has been performed
    let results: [ClippedRecipe]?
    //this array will be != nil if menu search has been performed
    let meals: [ClippedRecipe]?
    let nutrients: MenuNutrients?
    
    private enum CodingKeys: String, CodingKey {
        case recipes
        case results
        case meals
        case nutrients
    }
}
