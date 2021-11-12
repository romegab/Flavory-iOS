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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getRecipeByID(id: Int) -> RecipeModel? {
        let recipeFetchRequest: NSFetchRequest<RecipeModel>
        recipeFetchRequest = RecipeModel.fetchRequest()
        
        recipeFetchRequest.predicate = NSPredicate(
            format: "id = %id", id
        )
        
        do {
            let loadedRecipe = try context.fetch(recipeFetchRequest).first(where: { $0.isInProgress == true})
            
            return loadedRecipe
        }
        catch {
            print("get recipe by id is not wokring properly")
        }
        
        return nil
    }
    
    func getStartedRecipes() -> [RecipeModel]? {
        let recipeFetchRequest: NSFetchRequest<RecipeModel>
        recipeFetchRequest = RecipeModel.fetchRequest()
        
        recipeFetchRequest.predicate = NSPredicate(
            format: "isInProgress = %isInProgress", true
        )
        
        do {
            let loadedRecipes = try context.fetch(recipeFetchRequest)
            
            return loadedRecipes
        }
        catch {
            print("get started recipes is not wokring properly")
        }
        
        return nil
    }
    
    func getCountOfDishType(_ dishType: String) -> Int {
        let recipeFetchRequest: NSFetchRequest<RecipeModel>
        recipeFetchRequest = RecipeModel.fetchRequest()
        
        recipeFetchRequest.predicate = NSPredicate(
            format: "isInProgress = %isInProgress", false
        )
        
        do {
            let loadedRecipes = try context.fetch(recipeFetchRequest)
            var result = 0
            
            for currentRecipe in loadedRecipes {
                if currentRecipe.type == dishType {
                    result += 1
                }
            }
            return result
        }
        catch {
            print("get started recipes is not wokring properly")
        }
        
        return 0
    }
    
    func getDailyMenu() -> (DailyMenu?) {
        let currentData = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: currentData)
        
        let dailyMenuFetchRequest: NSFetchRequest<DailyMenu>
        dailyMenuFetchRequest = DailyMenu.fetchRequest()
        
        
        
        do {
            let loadedMenu = try context.fetch(dailyMenuFetchRequest).first(where: { $0.date == formattedDate})
            
            return loadedMenu
        }
        catch {
            print("get recipe by id is not wokring properly")
        }
        
        return nil
    }
    
    func getCookedRecipeInformation() -> (count: Int, spentTime: Int) {
        let recipeFetchRequest: NSFetchRequest<RecipeModel>
        recipeFetchRequest = RecipeModel.fetchRequest()

        recipeFetchRequest.predicate = NSPredicate(
            format: "isInProgress = %isInProgress", false
        )

        do {
            let loadedRecipes = try context.fetch(recipeFetchRequest)
            var count = 0
            var spentTime = 0

            for currentRecipe in loadedRecipes {
                if currentRecipe.origin == nil {
                    count += 1
                    spentTime += currentRecipe.preparationTime
                }
            }
            return (count, spentTime)
        }
        catch {
            print("get cooked recipes is not wokring properly")
        }
        
        return (0, 0)
    }
    
    func getMostCommonDishCategory() -> String {
        let recipeFetchRequest: NSFetchRequest<RecipeModel>
        recipeFetchRequest = RecipeModel.fetchRequest()

        recipeFetchRequest.predicate = NSPredicate(
            format: "isInProgress = %isInProgress", false
        )

        do {
            let loadedRecipes = try context.fetch(recipeFetchRequest)
            var categoryCounts = [String: Int]()
            for currentRecipe in loadedRecipes {
                if let diet = currentRecipe.diet{
                    if let count = categoryCounts[diet]{
                        categoryCounts[diet] = count + 1
                    } else {
                        if diet != " - "{
                            categoryCounts[diet] = 1
                        }
                        
                    }
                }
            }
            var mostCommonCategory = (category: " - ", count: 0)
            
            for currentCategory in categoryCounts {
                if currentCategory.value > mostCommonCategory.count && currentCategory.key != "-" {
                    mostCommonCategory.category = currentCategory.key
                    mostCommonCategory.count = currentCategory.value
                }
            }
            
            return mostCommonCategory.category
        }
        catch {
            print("get most common dish category is not wokring properly")
        }
        
        return "-"
    }
    
    func getStartedRecipesCount() -> Int {
        
        return getStartedRecipes()?.count ?? 0
        
    }
    
    func removeDailyMenu() {
        if let currentDaiLyMenu = getDailyMenu() {
            context.delete(currentDaiLyMenu)
        }
        do {
            try self.context.save()
        }
        catch {
            print("!!! problem with removing daily menu")
        }
    }
    
    func saveMenu(_ recipes: [ClippedRecipe], nutrients: MenuNutrients) {
        
        let newMenu = DailyMenu(context: self.context)
        
        let currentData = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: currentData)
        
        newMenu.date = formattedDate
        newMenu.calories = nutrients.calories ?? 0
        newMenu.protein = nutrients.protein ?? 0
        newMenu.fat = nutrients.fat ?? 0
        newMenu.carbohydrates = nutrients.carbohydrates ?? 0
        
        for currentRecipe in recipes {
            newMenu.addToRecipes(saveRecipe(currentRecipe))
        }
        
        do {
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the menu")
        }
    }
    
    func saveRecipe(_ recipe: ClippedRecipe) -> RecipeModel{
        let newRecipe = RecipeModel(context: self.context)
        
        newRecipe.id = recipe.id
        newRecipe.imageURL = recipe.largeImageURL
        newRecipe.title = recipe.title
        newRecipe.preparationTime = recipe.readyInMinutes ?? 0
        newRecipe.price = recipe.pricePerServing ?? 0
        newRecipe.detail = saveDetail(detail: recipe.recipeDetails)
        newRecipe.servings = recipe.servings ?? 0
        newRecipe.isInProgress = recipe.isInProgress
        newRecipe.type = recipe.dishType
        newRecipe.diet = recipe.diet
        print("-----------------\(newRecipe.diet)")
        newRecipe.progress = Int(recipe.progress)
        
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
        
        return newRecipe
    }
    
    func updateRecipe(_ recipe: ClippedRecipe) {
        do{
            if let loadedRecipe = getRecipeByID(id: recipe.id) {
                
                loadedRecipe.isInProgress = recipe.isInProgress
                loadedRecipe.progress = Int(recipe.progress)
                print(recipe.progress)
                updateIngredients(recipe, loadedRecipe)
                updateSteps(recipe, loadedRecipe)
                
                try self.context.save()
            }
        }
        catch{
            print("update recipe info problem")
        }
    }
    
    private func getRecipeLike(id: Int) -> RecipeLike? {
        let recipeLikeFetchRequest: NSFetchRequest<RecipeLike>
        recipeLikeFetchRequest = RecipeLike.fetchRequest()
        
        recipeLikeFetchRequest.predicate = NSPredicate(
            format: "id = %id", id
        )
        
        do {
            let loadedRecipeLike = try context.fetch(recipeLikeFetchRequest).first
            
            return loadedRecipeLike
        }
        catch {
            print("get recipe by id is not wokring properly")
        }
        
        return nil
    }
    
    func isRecipeLiked(id: Int) -> Bool {
        if let _  = getRecipeLike(id: id) {
            return true
        }
        return false
    }
    
    func updateRecipeLike(id: Int, isLiked: Bool) {
        let loadedRecipeLike = getRecipeLike(id: id)
        
        if loadedRecipeLike == nil && isLiked{
            saveRecipeLike(id: id)
        } else if loadedRecipeLike != nil && !isLiked{
            deleteRecipeLike(id: id)
        }
    }
    
    private func saveRecipeLike(id: Int){
        let newLike = RecipeLike(context: self.context)
        newLike.id = id
        
        do {
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the ingredient")
        }
    }
    
    private func deleteRecipeLike(id: Int){
        let loadedRecipeLike = getRecipeLike(id: id)
        if let loadedRecipeLike = loadedRecipeLike {
            context.delete(loadedRecipeLike)
            do {
                try self.context.save()
            }
            catch {
                print("!!! problem with saving the ingredient")
            }
        }
    }
    
    private func updateIngredients(_ recipe: ClippedRecipe, _ loadedRecipe: RecipeModel) {
        do {
            let loadedIngredients: [Ingredient] = loadedRecipe.ingredient ?? [Ingredient]()
            
            if let extendedIngredients = recipe.extendedIngredients {
                for currentIngredient in extendedIngredients {
                    if let ingredientToChange = loadedIngredients.first(where: { $0.id == currentIngredient.id}) {
                        ingredientToChange.isChecked = currentIngredient.isChecked
                    }
                }
                
                try self.context.save()
            }
        }
        catch {
            print("!!! problem with saving the ingredient")
        }
    }
    
    private func updateSteps(_ recipe: ClippedRecipe, _ loadedRecipe: RecipeModel) {
        do {
            let loadedSteps = loadedRecipe.step ?? [Step]()
            if let steps = recipe.steps{
                for currentStep in steps {
                    if let stepToChange = loadedSteps.first(where: { $0.step == currentStep.step}) {
                        stepToChange.isChecked = currentStep.isChecked
                    }
                }
            }
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the ingredient")
        }
    }
    
    private func saveIngredient(ingredient: RecipeIngredient) -> Ingredient {
        let newIngredient = Ingredient(context: self.context)
        
        newIngredient.name = ingredient.name
        newIngredient.ingredientDescription = ingredient.original
        newIngredient.isChecked = ingredient.isChecked
        newIngredient.image = ingredient.image
        newIngredient.id = ingredient.id ?? 0
        
        do {
            try self.context.save()
        }
        catch {
            print("!!! problem with saving the ingredient")
        }
        
        return newIngredient
    }
    
    private func saveStep(step: RecipeStep) -> Step {
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
    
    private func saveDetail(detail: RecipeDetails) -> Detail {
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
