//
//  RecipeRegexExctractor.swift
//  Flavory
//
//  Created by Ivan Stoilov on 5.10.21.
//

import Foundation

class RecipeDetails{
    
    let regex = try! NSRegularExpression(pattern: "<b>*<b>")
    
    var calories: String?
    var protein: String?
    var fat: String?
    var pricePerServing: String?
    
    func loadData( recipeSumary: String){
        let rawDetails = extractRawDetails(recipeSumary: recipeSumary)
        
        print(rawDetails)
    }
    
    private func extractRawDetails(recipeSumary: String) -> [String] {
        let results = regex.matches(in: recipeSumary, range: NSRange(recipeSumary.startIndex..., in: recipeSumary))
        return results.map { String(recipeSumary[Range($0.range, in: recipeSumary)!]) }
    }
}
