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
        
        let cellNib = UINib(nibName: "IngredientCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                                    "IngredientCell")
        
        tableView.reloadData()
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: RecipeIngredient) {
      let label = cell.viewWithTag(1001) as! UILabel
      if item.isChecked {
        label.text = "✓"
      } else {
        label.text = ""
      }
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
  

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let cell = tableView.cellForRow(at: indexPath) {
        let item = ingredients[indexPath.row]
        item.isChecked.toggle()
        configureCheckmark(for: cell, with: item)
      }
      tableView.deselectRow(at: indexPath, animated: true)
    }

//  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//    switch search.state {
//    case .notSearchedYet, .loading, .noResults:
//      return nil
//    case .results:
//      return indexPath
//    }
//  }
    
   
}
