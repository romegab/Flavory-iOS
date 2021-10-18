//
//  DataManager.swift
//  Flavory
//
//  Created by Ivan Stoilov on 15.10.21.
//


import UIKit
import CoreData

class DataManager {
    
    static let shared = DataManager()

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveRecipe(_ recipe: ClippedRecipe) {
        let newRecipe = RecipeModel(context: self.context)
        
        newRecipe.id = recipe.id
        newRecipe.title = recipe.title
        newRecipe.preparationTime = recipe.readyInMinutes
        newRecipe.price = recipe.recipePrice
        newRecipe.detail = saveDetail(detail: recipe.recipeDetails)
        newRecipe.servings = recipe.servings ?? 0
        
        if let ingredients = recipe.extendedIngredients {
            for currentIngredient in ingredients{
                newRecipe.addToIngredient(saveIngredient(ingredient: currentIngredient))
            }
        }
        
        if let steps = recipe.steps {
            for currentStep in steps{
                newRecipe.addToStep(saveStep(step: currentStep))
            }
        }
        
        do {
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the recipe")
        }
    }
    
    func updateRecipe(_ recipe: ClippedRecipe) {
        
        let recipeFetchRequest: NSFetchRequest<RecipeModel>
        recipeFetchRequest = RecipeModel.fetchRequest()

        recipeFetchRequest.predicate = NSPredicate(
            format: "id = %id", recipe.id
        )
        
        updateIngredients(recipe, recipeFetchRequest)
        updateSteps(recipe, recipeFetchRequest)
        
    }
    
    private func updateIngredients(_ recipe: ClippedRecipe, _ recipeFetchRequest: NSFetchRequest<RecipeModel>) {
        do {
            let loadedRecipe = try context.fetch(recipeFetchRequest)[0]
            let loadedIngredients = loadedRecipe.ingredient?.allObjects as? [Ingredient]
            
            for currentIngredient in recipe.extendedIngredients! {
                if let ingredientToChange = loadedIngredients?.first(where: { $0.id == currentIngredient.id}) {
                    ingredientToChange.isChecked = currentIngredient.isChecked
                }
            }
            
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the ingredient")
        }
    }
    
    private func updateSteps(_ recipe: ClippedRecipe, _ recipeFetchRequest: NSFetchRequest<RecipeModel>) {
        do {
            let loadedRecipe = try context.fetch(recipeFetchRequest)[0]
            let loadedSteps = loadedRecipe.step?.allObjects as? [Step]
            
            for currentStep in recipe.steps! {
                if let stepToChange = loadedSteps?.first(where: { $0.step == currentStep.step}) {
                    stepToChange.isChecked = currentStep.isChecked
                }
            }
            
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the ingredient")
        }
    }
    
    private func saveIngredient(ingredient: RecipeIngredient) -> Ingredient{
        let newIngredient = Ingredient(context: self.context)
        
        newIngredient.name = ingredient.name
        newIngredient.ingredientDescription = ingredient.original
        newIngredient.isChecked = ingredient.isChecked
        newIngredient.imageURL = ingredient.imageURL
        newIngredient.id = ingredient.id
        
        do {
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the ingredient")
        }
        
        return newIngredient
    }
    
    private func saveStep(step: RecipeStep) -> Step{
        let newStep = Step(context: self.context)
        
        newStep.number = step.number
        newStep.step = step.step
        newStep.isChecked = step.isChecked
        
        do {
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the step")
        }
        
        return newStep
    }
    
    private func saveDetail(detail: RecipeDetails) -> Detail{
        let newDetail = Detail(context: self.context)
        
        newDetail.calories = detail.calories ?? 0
        newDetail.protein = detail.protein ?? 0
        newDetail.fat = detail.fat ?? 0
        newDetail.recipeDescription = detail.description
        
        do {
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the detail")
        }
        
        return newDetail
    }
}
