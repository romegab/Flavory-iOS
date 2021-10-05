//
//  RecipeRegexExctractor.swift
//  Flavory
//
//  Created by Ivan Stoilov on 5.10.21.
//

import Foundation

class RecipeDetails{
    
    let regex = try! NSRegularExpression(pattern: "<b>[a-z, 0-9]*</b>")
    
    var calories: Int?
    var protein: Int?
    var fat: Int?
    
    
    func loadData( recipeSumary: String){
        
        var sentences: [String] = []
        recipeSumary.enumerateSubstrings(in: recipeSumary.startIndex..., options: .bySentences) { (string, range, enclosingRamge, stop) in
            if sentences.count < 4{
                if var sentence = string{
                    sentence = sentence.replacingOccurrences(of: "<b>", with: "")
                    sentence = sentence.replacingOccurrences(of: "</b>", with: "")
                    sentences.append(sentence)
                }
            }
        }
        print(sentences)
        
        let rawDetails = extractRawDetails(recipeSumary: recipeSumary)
        for detail in rawDetails {
            if detail.contains("calories") {
                if let digitValue = Int(detail.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                    calories = digitValue
                }
            }
            else if detail.contains("protein"){
                if let digitValue = Int(detail.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                    protein = digitValue
                }
            }
            else if detail.contains("fat"){
                if let digitValue = Int(detail.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                    fat = digitValue
                }
            }
        }
    }
    
    private func extractRawDetails(recipeSumary: String) -> [String] {
        let results = regex.matches(in: recipeSumary, range: NSRange(recipeSumary.startIndex..., in: recipeSumary))
        return results.map { String(recipeSumary[Range($0.range, in: recipeSumary)!]) }
    }
}
