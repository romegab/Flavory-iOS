//
//  ClippedRecipe.swift
//  Flavory
//
//  Created by Ivan Stoilov on 27.09.21.
//

import Foundation

class ClippedRecipe: Codable {
    
    lazy var recipeDetails: RecipeDetails = {
        let details = RecipeDetails()
        
        if let summary = summary {
            details.loadData(recipeSumary: summary)
        }
        return details
    }()
    
    lazy var progress: Double = {
        var totalStages = (extendedIngredients?.count ?? 0) + (steps?.count ?? 0)
        var doneStages = ((extendedIngredients?.filter{  $0.isChecked == true })?.count ?? 0) + ((steps?.filter{  $0.isChecked == true })?.count ?? 0)
        
        if totalStages != 0 {
            return Double( doneStages / ( totalStages / 100 ) )
        }
        else {
            return 0.0
        }
        
    }()
    
    var largeImageURL: String {
        get {
        return "https://spoonacular.com/recipeImages/\(id)-636x393.jpg"
        }
    }
    var smallImageURL: String {
        get {
        return "https://spoonacular.com/recipeImages/\(id)-636x393.jpg"
        }
    }
    
    var recipePrice: Double{
        get{
            if let pricePerServing = pricePerServing{
                if let servings = servings{
                    return Double((Int(pricePerServing) * servings) / 100)
                }
            }
            
            return 0.0
        }
    }
    
    var steps: [RecipeStep]? {
        get {
            if let analyzedInstructions = analyzedInstructions{
            return analyzedInstructions[0].steps
            } else {
                return nil
            }
        }
        set {
            
        }
    }
    
    let title: String
    let id: Int
    let readyInMinutes: Int?
    let pricePerServing: Double?
    let servings: Int?
    private var summary: String?
    var extendedIngredients: [RecipeIngredient]?
    private var analyzedInstructions: [AnalyzedInstruction]?
    var isInProgress: Bool = false
    
    
    private enum CodingKeys: String, CodingKey {
        case title
        case id
        case readyInMinutes
        case servings
        case summary
        case pricePerServing
        case extendedIngredients
        case analyzedInstructions
    }
    
    func extractSteps(rawSteps: [Step]) -> [RecipeStep]
    {
        var result: [RecipeStep] = [RecipeStep]()
        
        for step in rawSteps {
            let currentStep = RecipeStep(from: step)
            
            result.append(currentStep)
        }
        
        return result
    }
    
    func extractIngrediets(rawIngredients: [Ingredient]) -> [RecipeIngredient]
    {
        var result: [RecipeIngredient] = [RecipeIngredient]()
        
        for ingredient in rawIngredients {
            let currentIngredient = RecipeIngredient(from: ingredient)
            
            result.append(currentIngredient)
        }
        
        return result
    }
    
    init (loadedRecipe: RecipeModel) {
        
        //extract the details from the already loaded recipe
        let details: RecipeDetails = RecipeDetails()
        details.description = loadedRecipe.detail?.recipeDescription ?? ""
        details.protein = loadedRecipe.detail?.protein
        details.fat = loadedRecipe.detail?.fat
        details.calories = loadedRecipe.detail?.calories
        
        //extracting the steps from the already loaded recipe
        
        self.title = loadedRecipe.title ?? ""
        self.id = loadedRecipe.id
        self.readyInMinutes = loadedRecipe.preparationTime
        self.pricePerServing = loadedRecipe.price
        self.servings = loadedRecipe.servings
        self.recipeDetails = details
        self.isInProgress = loadedRecipe.isInProgress
        
        if let rawSteps = loadedRecipe.step {
            let extractedSteps: [RecipeStep] = extractSteps(rawSteps: rawSteps)
            var instructions: [AnalyzedInstruction] = [AnalyzedInstruction]()
            instructions.append(AnalyzedInstruction(steps: extractedSteps))
            self.analyzedInstructions = instructions
        }
        
        if let rawIngredients = loadedRecipe.ingredient {
            let extractedIngredients: [RecipeIngredient] = extractIngrediets(rawIngredients: rawIngredients)
            self.extendedIngredients = extractedIngredients
        }
        
    }
    
    
}
