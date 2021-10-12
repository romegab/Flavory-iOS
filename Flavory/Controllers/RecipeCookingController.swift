//
//  RecipeCookingController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 11.10.21.
//

import UIKit

class RecipeCookingController: UIViewController {
    
    var ingredients: [RecipeIngredient] = [RecipeIngredient]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ingredientCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                                    "ingredientCell")
        
        tableView.reloadData()
    }
}

// MARK: - Table View Delegate
extension RecipeCookingController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      return ingredients.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
      let currentIngredient = ingredients[indexPath.row]
      cell.ingredient = currentIngredient
      return cell
    }
  

//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
//  }

//  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//    switch search.state {
//    case .notSearchedYet, .loading, .noResults:
//      return nil
//    case .results:
//      return indexPath
//    }
//  }
}
