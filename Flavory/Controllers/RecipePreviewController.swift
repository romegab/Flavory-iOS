//
//  RecipePreviewController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 4.10.21.
//

import UIKit

class RecipePreviewController: UIViewController {
    
    @IBOutlet fileprivate weak var closeButton: UIButton!
    @IBOutlet fileprivate weak var recipeImage: UIImageView!
    @IBOutlet fileprivate weak var recipeTitle: UILabel!
    @IBOutlet fileprivate weak var recipeCategory: UILabel!
    @IBOutlet fileprivate weak var recipeDescription: UILabel!
    
    @IBOutlet fileprivate weak var recipeFat: UILabel!
    @IBOutlet fileprivate weak var recipeProtein: UILabel!
    @IBOutlet fileprivate weak var recipeKcal: UILabel!
    @IBOutlet fileprivate weak var recipePrice: UILabel!
    @IBOutlet fileprivate weak var startCoookingButotn: UIButton!
    @IBOutlet fileprivate weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var likeButton: UIButton!
    
    
    private var imageRequest: Cancellable?
    var recipe: ClippedRecipe? {
        didSet {
            if let recipe = recipe {
                isLiked = DataManager.shared.isRecipeLiked(id: recipe.id)
            }
        }
    }
    private var isLiked: Bool? {
        didSet {
            updateLikedButton()
        }
    }
    
    override func viewDidLoad() {
        updateLikedButton()
        recipeImage.alpha = 0
        imageLoadingIndicator.startAnimating()
        updateUI()
        setUpCloseButton()
        setUpRecipeImage()
        setUpRecipeNutrients()
        
        //set button appear settings
        startCoookingButotn.layer.cornerRadius = 15
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        isLiked?.toggle()
    }
    
    private func updateLikedButton() {
        if let isLiked = isLiked, let likeButton = likeButton {
            if isLiked {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    private func updateUI() {
        if let recipe = recipe{
            if recipe.isInProgress {
                startCoookingButotn.setTitle("CONTINUE COOKING", for: .normal)
            }
            recipeTitle.text = recipe.title
            recipeTitle.adjustsFontSizeToFitWidth = true
            recipeCategory.text = recipe.diet
            recipeImage.image = UIImage(named: "Placeholder")
            imageRequest = ImageService.shared.getImage(rawUrl: recipe.largeImageURL) { [weak self] result in
                
                switch result{
                case .success(let image):
                    self?.imageLoadingIndicator.stopAnimating()
                    self?.recipeImage.image = image
                    UIView.animate(withDuration: 0.5) {
                        self?.recipeImage.alpha = 1
                    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipeCookingController {
            let vc = segue.destination as? RecipeCookingController
            vc?.recipe = recipe
            startCoookingButotn.setTitle("CONTINUE COOKING", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let isLiked = isLiked, let id = recipe?.id {
            DataManager.shared.updateRecipeLike(id: id, isLiked: isLiked)
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



