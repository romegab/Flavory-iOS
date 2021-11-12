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
    
     var progress: Double{
         get{
            let totalStages = (extendedIngredients?.count ?? 0) + (steps?.count ?? 0)
            let doneStages = ((extendedIngredients?.filter{  $0.isChecked == true })?.count ?? 0) + ((steps?.filter{  $0.isChecked ==       true })?.count ?? 0)
            
            if totalStages != 0, doneStages != 0 {
                let valuePerPercent: Double = Double( Double( totalStages ) / 100.0 )
                let result: Double = ceil( Double( doneStages ) / valuePerPercent )
                return result
            }
            else {
                return 0.0
            }
         }
     }
    
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
    
    var dishType: String {
        if let dishTypes = dishTypes{
            if dishTypes.contains("main course") {
                return "main course"
            } else if dishTypes.contains("side dish") {
                return "side dish"
            } else if dishTypes.contains("dessert") {
                return "dessert"
            } else if dishTypes.contains("salad") {
                return "salad"
            } else if dishTypes.contains("soup") {
                return "soup"
            }
        }
        return ""
    }
    
    var recipePrice: Double{
        get{
            if let pricePerServing = pricePerServing{
                if let servings = servings{
                    return Double(  pricePerServing * Double( servings ) / 100.0)
                }
            }
            
            return 0.0
        }
    }
    
    var steps: [RecipeStep]? {
        get {
            if let analyzedInstructions = analyzedInstructions, analyzedInstructions.count > 0{
                return analyzedInstructions[0].steps
            } else {
                return nil
            }
        }
        set {
        }
    }
    
    var diet: String {
        get {
            if let diets = diets {
                if diets.count > 0 {
                    return diets[0]
                } else {
                    return " - "
                }
            } else {
                return " - "
            }
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
    private var dishTypes: [String]?
    private var diets: [String]?
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
        case dishTypes
        case diets
    }
    
    private func extractSteps(rawSteps: [Step]) -> [RecipeStep]
    {
        var result: [RecipeStep] = [RecipeStep]()
        
        for step in rawSteps {
            let currentStep = RecipeStep(from: step)
            
            result.append(currentStep)
        }
        
        return result
    }
    
    private func extractIngrediets(rawIngredients: [Ingredient]) -> [RecipeIngredient]
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
        self.diets = [String]()
        diets?.append(loadedRecipe.diet ?? "-")
        
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
