//
//  RecipeCookingController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 11.10.21.
//

import UIKit

class RecipeCookingController: UIViewController {
    
    @IBOutlet private weak var recipeTitleLable: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var readyButton: UIButton!
    
    private var currentSegmentIndex = 1
    var recipe: ClippedRecipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTitleLable.text = recipe?.title
        recipeTitleLable.adjustsFontSizeToFitWidth = true
        readyButton.layer.cornerRadius = 15
        
        let ingredientCellNib = UINib(nibName: "IngredientCell", bundle: nil)
        tableView.register(ingredientCellNib, forCellReuseIdentifier: "IngredientCell")
        
        let cookingStepCellNib = UINib(nibName: "CookingStepCell", bundle: nil)
        tableView.register(cookingStepCellNib, forCellReuseIdentifier: "CookingStepCell")
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let recipe = recipe {
            DataManager.shared.updateRecipe(recipe)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let recipe = recipe {
            DataManager.shared.updateRecipe(recipe)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if currentSegmentIndex == 1 {
            currentSegmentIndex = 2
        }
        else {
            currentSegmentIndex = 1
        }
        
        tableView.reloadData()
    }
    
    @IBAction func readyButtonClicked(_ sender: Any) {
        if let recipe = recipe {
            recipe.isInProgress.toggle()
            for currentIngredient in recipe.extendedIngredients ?? [] {
                currentIngredient.isChecked = false
            }
            
            for currentStep in recipe.steps ?? [] {
                currentStep.isChecked = false
            }
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View Delegate
extension RecipeCookingController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSegmentIndex == 1{
            return recipe?.extendedIngredients?.count ?? 0
        } else {
            return recipe?.steps?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
            let currentIngredient = recipe?.extendedIngredients?[indexPath.row]
            cell.ingredient = currentIngredient
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CookingStepCell", for: indexPath) as! CookingStepCell
            let currentStep = recipe?.steps?[indexPath.row]
            cell.cookingStep = currentStep
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if var cell: Checkable = tableView.cellForRow(at: indexPath) as? Checkable{
            cell.isChecked.toggle()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
