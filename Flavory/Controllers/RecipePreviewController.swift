//
//  RecipePreviewController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 4.10.21.
//

import UIKit

class RecipePreviewController: UIViewController {
    
    var downloadTask: URLSessionDownloadTask?
    var recipe: ClippedRecipe?{
        didSet{
            
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeCategory: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    
    @IBOutlet weak var recipeFat: UILabel!
    @IBOutlet weak var recipeProtein: UILabel!
    @IBOutlet weak var recipeKcal: UILabel!
    @IBOutlet weak var recipePrice: UILabel!
    override func viewDidLoad() {
        
        updateUI()
        setUpCloseButton()
        setUpRecipeImage()
        setUpRecipeNutrients() 
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadRecipeInformation() {
        
    }
        
    private func updateUI() {
        if let recipe = recipe{
            
            recipeTitle.text = recipe.title
            recipeTitle.adjustsFontSizeToFitWidth = true
            recipeImage.image = UIImage(named: "Placeholder")
            if let smallURL = URL(string: recipe.imageURL) {
              downloadTask = recipeImage.loadImage(url: smallURL)
            }
            recipeDescription.text = recipe.recipeDetails.description
            recipePrice.text = "$\(String(format: "%.2f", recipe.recipePrice))"
        }
    }
    
    private func setUpCloseButton() {
        closeButton.layer.cornerRadius = 30
        closeButton.layer.masksToBounds = false
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        
        if UITraitCollection.current.userInterfaceStyle == .dark {
            closeButton.backgroundColor = UIColor.black
            closeButton.tintColor = UIColor.white
        }
        else {
            
            closeButton.backgroundColor = UIColor.white
            closeButton.tintColor = UIColor.black
        }
    }
    
    private func setUpRecipeImage() {
        recipeImage.layer.cornerRadius = 15
        recipeImage.clipsToBounds = true
        recipeImage.layer.masksToBounds = true
    }
    
    private func setUpRecipeNutrients() {
        recipeKcal.text = String(recipe?.recipeDetails.calories ?? 0)
        recipeProtein.text = String(recipe?.recipeDetails.protein ?? 0)
        recipeFat.text = String(recipe?.recipeDetails.fat ?? 0)
    }
}



