//
//  RecipeCookingController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 11.10.21.
//

import UIKit

class RecipeCookingController: UIViewController {
    
    private let ingredients: [RecipeIngredient] = [RecipeIngredient]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ingredientCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                                    "ingredientCell")
    }
}

