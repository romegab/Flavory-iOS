//
//  ResultArray.swift
//  Flavory
//
//  Created by Ivan Stoilov on 27.09.21.
//

import Foundation

class ResultArray: Codable {
    let recipes: [ClippedRecipe]?
    let results: [ClippedRecipe]?
    
    private enum CodingKeys: String, CodingKey {
        case recipes
        case results
    }
}
