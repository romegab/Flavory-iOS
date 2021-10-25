//
//  RecipePreviewController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 4.10.21.
//

import UIKit

class RecipePreviewController: UIViewController {
    private var imageRequest: Cancellable?
    
    //recipe will be != nil if it is from the API response
    var recipe: ClippedRecipe?

    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeCategory: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    
    @IBOutlet weak var recipeFat: UILabel!
    @IBOutlet weak var recipeProtein: UILabel!
    @IBOutlet weak var recipeKcal: UILabel!
    @IBOutlet weak var recipePrice: UILabel!
    @IBOutlet weak var startCoookingButotn: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        
        updateUI()
        setUpCloseButton()
        setUpRecipeImage()
        setUpRecipeNutrients()
        
        //set button appear settings
        startCoookingButotn.layer.cornerRadius = 15
        //likeButton.layer.cornerRadius = 15
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
        
    private func updateUI() {
        if let recipe = recipe{
            if recipe.isInProgress {
                startCoookingButotn.setTitle("CONTINUE COOKING", for: .normal)
            }
            recipeTitle.text = recipe.title
            recipeTitle.adjustsFontSizeToFitWidth = true
            recipeImage.image = UIImage(named: "Placeholder")
            imageRequest = ImageService.shared.getImage(rawUrl: recipe.largeImageURL) { [weak self] result in
                
                switch result{
                case .success(let image):
                    self?.recipeImage.image = image
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
            recipeDescription.text = recipe.recipeDetails.description
            recipePrice.text = "$\(String(format: "%.2f", recipe.recipePrice))"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is RecipeCookingController {
            let vc = segue.destination as? RecipeCookingController
            vc?.recipe = recipe
            startCoookingButotn.setTitle("CONTINUE COOKING", for: .normal)
        }
    }
    
    @IBAction func startCookingButtonPressed(_ sender: UIButton) {
        if let recipe = recipe, !recipe.isInProgress{
            recipe.isInProgress.toggle()
            DataManager.shared.saveRecipe(recipe)
        }
        performSegue(withIdentifier: "StartCookingSegue", sender: nil)
        
    }
    
    private func setUpCloseButton() {
        closeButton.layer.cornerRadius = 30
        closeButton.layer.masksToBounds = false
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        
    }
    
    private func setUpRecipeImage() {
        recipeImage.layer.cornerRadius = 15
        recipeImage.clipsToBounds = true
        recipeImage.layer.masksToBounds = true
    }
    
    private func setUpRecipeNutrients() {
        if let recipe = recipe {
            recipeKcal.text = String(recipe.recipeDetails.calories ?? 0)
            recipeProtein.text = String(recipe.recipeDetails.protein ?? 0)
            recipeFat.text = String(recipe.recipeDetails.fat ?? 0)
        }
        
    }
}



