//
//  RecipeStep.swift
//  Flavory
//
//  Created by Ivan Stoilov on 14.10.21.
//

import Foundation

struct RecipeStep: Codable {
    let number: Int
    let step: String
    var isChecked: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case number
        case step
    }
}
