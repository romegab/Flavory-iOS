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
            
            if result.recipes != nil {
                return result.recipes!
            } else if result.results != nil {
                return result.results!
            }
        } catch {
            print("JSON Error: \(error)")
        }
        return [ClippedRecipe]()
    }
    
    static func parseCertainRecipe(data: Data) -> ClippedRecipe? {
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ClippedRecipe.self, from:data)
            
            return result
            
        } catch {
            print("JSON Error: \(error)")
        }
        return nil
    }
    
    static func parseDailyMenu(data: Data) -> ([ClippedRecipe], MenuNutrients) {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from:data)
            
            return (result.meals!, result.nutrients!)
        } catch {
            print("JSON Error: \(error)")
        }
        return ([ClippedRecipe](), MenuNutrients())
    }
}
