//
//  SearchResultParser.swift
//  Flavory
//
//  Created by Ivan Stoilov on 28.09.21.
//

import Foundation

class SearchResultParser{
    
    static func parse(data: Data) -> [ClippedRecipe] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from:data)
  
            return result.recipes
            
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
}
