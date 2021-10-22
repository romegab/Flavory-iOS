//
//  AnalyzedInstructionArray.swift
//  Flavory
//
//  Created by Ivan Stoilov on 14.10.21.
//

import Foundation

class AnalyzedInstruction: Codable {
    
    let name: String?
    let steps: [RecipeStep]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case steps
    }
}
