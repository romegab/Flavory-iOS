
import UIKit

class StartedRecipeController: UIViewController {
    
    var startedRecipes: [ClippedRecipe] = [ClippedRecipe]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        recipeTitleLable.text = recipe?.title
        recipeTitleLable.adjustsFontSizeToFitWidth = true
        readyButton.layer.cornerRadius = 15
        
        let ingredientCellNib = UINib(nibName: "IngredientCell", bundle: nil)
        tableView.register(ingredientCellNib, forCellReuseIdentifier:
                                    "IngredientCell")
        
        let cookingStepCellNib = UINib(nibName: "CookingStepCell", bundle: nil)
        tableView.register(cookingStepCellNib, forCellReuseIdentifier:
                                    "CookingStepCell")
        
        tableView.reloadData()
    }
}
