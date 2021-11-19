//
//  search.swift
//  Flavory
//
//  Created by Ivan Stoilov on 27.09.21.
//

import Foundation

enum NetworkError: Error {
    case badConnection
}

class Search {
    
    private var isRequestFinished: Bool = false
    private let searchParser: SearchResultParser = SearchResultParser()
    private var dataTask: URLSessionDataTask?
    private let session = URLSession.shared
    //private let apiKey: String = "12cbc8a03407496290efed34fba57028"
    private let apiKey: String = "5d9a3e69b4234101a69aab06fbae2aae"
    //private let apiKey: String = "3b4becbee2e143f18c78ba7f929bbfd4"
    //private let apiKey: String = "a853b2a46bc743db882b2c8a48b76329"
    
    func terminateRequest() {
            session.invalidateAndCancel()
            dataTask?.cancel()
    }
    
    func performRandomSearch(_ count: Int, completionHandler: @escaping (Result<[ClippedRecipe], NetworkError>) -> Void){
        let url: URL = randomSearchURL(count)
        
        performRequest(with: url) { result in
            switch result{
            case .success(let recipies):
                DispatchQueue.main.async{
                    completionHandler(.success(recipies))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(.failure(.badConnection))
            }
        }
    }
    
    func performRecipeSearch (_ recipe: String, completionHandler: @escaping (Result<[ClippedRecipe], NetworkError>) -> Void){
        let url:URL = searchURL(searchText: recipe)
        
        performRequest(with: url) { result in
            switch result{
            case .success(let recipies):
                DispatchQueue.main.async{
                    completionHandler(.success(recipies))
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(.failure(.badConnection))
                }
            }
        }
    }
    
    func performSearchByID (_ id: String, completionHandler: @escaping (Result<ClippedRecipe, NetworkError>) -> Void){
        let url:URL = idSearchURL(id)
        
        isRequestFinished = false
        let session = URLSession.shared
        
        session.dataTask(with: url) {data, response, error in
            
            if let error = error as NSError?, error.code == -999{
                DispatchQueue.main.async {
                    self.isRequestFinished = true
                    completionHandler(.failure(.badConnection))
                }
            } else if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                self.isRequestFinished = true
                if let data = data {
                    completionHandler(.success(self.searchParser.parseCertainRecipe(data: data)!))
                }
            }
        }.resume()
    }
    
    func performMenuSearch (completionHandler: @escaping (Result<([ClippedRecipe], MenuNutrients), NetworkError>) -> Void){
        let url:URL = menuURL()
        
        isRequestFinished = false
        let session = URLSession.shared
        
        session.dataTask(with: url) {data, response, error in
            
            if let error = error as NSError?, error.code == -999{
                DispatchQueue.main.async {
                    self.isRequestFinished = true
                    completionHandler(.failure(.badConnection))
                }
            } else if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                self.isRequestFinished = true
                if let data = data {
                    completionHandler(.success(self.searchParser.parseDailyMenu(data: data)))
                }
            }
        }.resume()
    }
    
    func performIngredientSearch (query: String, completionHandler: @escaping (Result<[RecipeIngredient], NetworkError>) -> Void) {
        let url:URL = ingredientSearchURL(query)
        
        isRequestFinished = false
        let session = URLSession.shared
        
        session.dataTask(with: url) {data, response, error in
            
            if let error = error as NSError?, error.code == -999{
                DispatchQueue.main.async {
                    self.isRequestFinished = true
                    completionHandler(.failure(.badConnection))
                }
            } else if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                self.isRequestFinished = true
                if let data = data {
                    completionHandler(.success(SearchResultParser.parseIngredients(data: data) ?? [RecipeIngredient]()))
                }
            }
        }.resume()
    }
    
    func performSearchByIngredients (filters: FilterSet, completionHandler: @escaping (Result<[ClippedRecipe], NetworkError>) -> Void) {
        if let ingredients = filters.ingredients{
            let url:URL = recipeSearchByIngredientsURL(ingredients: ingredients)
            
            isRequestFinished = false
            let session = URLSession.shared
            
            session.dataTask(with: url) {data, response, error in
                
                if let error = error as NSError?, error.code == -999{
                    DispatchQueue.main.async {
                        self.isRequestFinished = true
                        completionHandler(.failure(.badConnection))
                    }
                } else if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                    self.isRequestFinished = true
                    if let data = data {
                       print( String(decoding: data, as: UTF8.self))
                        completionHandler(.success(self.searchParser.parseRecipeByIngredients(data: data)))
                    }
                }
            }.resume()
        }
    }
    
    func performNutrientsSearch (filters: FilterSet, completionHandler: @escaping (Result<[ClippedRecipe], NetworkError>) -> Void) {
        let url:URL = nutrientsSearchURL(filters: filters)
        
        isRequestFinished = false
        let session = URLSession.shared
        
        session.dataTask(with: url) {data, response, error in
            
            if let error = error as NSError?, error.code == -999{
                DispatchQueue.main.async {
                    self.isRequestFinished = true
                    completionHandler(.failure(.badConnection))
                }
            } else if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                self.isRequestFinished = true
                if let data = data {
                    completionHandler(.success(self.searchParser.parseRecipeByIngredients(data: data)))
                }
            }
        }.resume()
    
    }
    
    private func performRequest(with url: URL, completionHandler: @escaping (Result<[ClippedRecipe], NetworkError>) -> Void) {
        isRequestFinished = false
        //let session = URLSession.shared
        
        session.dataTask(with: url) {data, response, error in
            if let error = error as NSError?, error.code == -999{
                self.isRequestFinished = true
                completionHandler(.failure(.badConnection))
            } else if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                self.isRequestFinished = true
                if let data = data {

                    completionHandler(.success(self.searchParser.parse(data: data)))
                }
            }
        }.resume()
    }
    
    private func ingredientSearchURL(_ query:String) -> URL {
        let urlString = "https://api.spoonacular.com/food/ingredients/search?query=\(query)&apiKey=\(apiKey)"
        let url = URL(string: urlString)
        return url!
    }
    
    private func randomSearchURL(_ count: Int) -> URL {
        let urlString = "https://api.spoonacular.com/recipes/random?number=\(count)&apiKey=\(apiKey)"
        let url = URL(string: urlString)
        return url!
    }
    
    private func idSearchURL(_ id: String) -> URL {
        let urlString = "https://api.spoonacular.com/recipes/\(id)/information?apiKey=\(apiKey)"
        let url = URL(string: urlString)
        return url!
    }
    
    private func searchURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(encodedText)&apiKey=\(apiKey)"
        let url = URL(string: urlString)
        return url!
    }
    
    private func menuURL() -> URL {
        let urlString = "https://api.spoonacular.com/mealplanner/generate?timeFrame=day&apiKey=\(apiKey)"
        let url = URL(string: urlString)
        return url!
    }
    
    private func recipeSearchByIngredientsURL(ingredients: [RecipeIngredient]) -> URL {
        var ingredientsToString = ""
        for ingredient in ingredients {
            if let name = ingredient.name {
                ingredientsToString += ",\(name.replacingOccurrences(of: " ", with: "%20"))"
            }
        }
        
        ingredientsToString.removeFirst()
        
        let urlString = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(ingredientsToString)&apiKey=\(apiKey)"
        print(urlString)
        let url = URL(string: urlString)
        return url!
    }
    
    private func nutrientsSearchURL(filters: FilterSet) -> URL {
        let urlString = "https://api.spoonacular.com/recipes/findByNutrients?minCarbs=\(filters.minCarbs)&maxCarbs=\(filters.maxCarbs)&minProtein=\(filters.minProtein)&maxProtein=\(filters.maxProtein)&minCalories=\(filters.minCalories)&maxCalories=\(filters.maxCalories)&minFat=\(filters.minFat)&maxFat=\(filters.maxFat)&apiKey=\(apiKey)"
        let url = URL(string: urlString)
        return url!
    }
}
