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
    private var isRequestFinished = true
    var searchResults: [ClippedRecipe]? = [ClippedRecipe]()
    var dataTask: URLSessionDataTask?
    let queue = DispatchQueue.global()
    
    private let apiKey: String = "3b4becbee2e143f18c78ba7f929bbfd4"
    
    func terminateRequest() {
        if !isRequestFinished{
            dataTask?.cancel()
        }
    }
    
    func performRandomSearch(_ count: Int, completionHandler: @escaping (Result<[ClippedRecipe], NetworkError>) -> Void){
        let url: URL = randomSearchURL(count)
        
        performRequest(with: url) { result in
            switch result{
            case .success(let recipies):
                self.searchResults = recipies
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
    
    func performRecipeSearch (_ recipe: String, completionHandler: @escaping (Result<[ClippedRecipe], NetworkError>) -> Void){
        
        let url:URL = searchURL(searchText: recipe)
        
        performRequest(with: url) { result in
            switch result{
            case .success(let recipies):
                self.searchResults = recipies
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
                    completionHandler(.success(SearchResultParser.parseCertainRecipe(data: data)!))
                }
            }
        }.resume()
    }
    
    private func performRequest(with url: URL, completionHandler: @escaping (Result<[ClippedRecipe], NetworkError>) -> Void) {
        
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
                    

                    completionHandler(.success(SearchResultParser.parse(data: data)))
                }
            }
        }.resume()
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

}
