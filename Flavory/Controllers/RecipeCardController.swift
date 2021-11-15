//
//  CollectionViewCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 29.09.21.
//

import UIKit

class RecipeCardController: UICollectionViewCell {
    
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var recipeTitle: UILabel!
    @IBOutlet private weak var background: UIView!
    @IBOutlet private weak var recipePreparationTime: UILabel!
    @IBOutlet private weak var recipeServings: UILabel!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    
    private var imageRequest: Cancellable?
    
    var recipe: ClippedRecipe? {
        didSet{
            recipeImage.alpha = 0
            imageLoadingIndicator.startAnimating()
            updateUI()
        }
    }
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageLoadingIndicator.startAnimating()
        
        recipeTitle.adjustsFontSizeToFitWidth = true
        recipePreparationTime.adjustsFontSizeToFitWidth = true
        recipeServings.adjustsFontSizeToFitWidth = true
        
        recipeImage.layer.cornerRadius = 15
        background.layer.cornerRadius = 15
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageRequest?.cancel()
    }
    
    private func updateUI() {
        recipeImage.image = nil
        
        recipeTitle.adjustsFontSizeToFitWidth = true
        recipePreparationTime.adjustsFontSizeToFitWidth = true
        recipeServings.adjustsFontSizeToFitWidth = true
        
        if let recipe = recipe {
            
            recipeTitle.text = recipe.title
            recipePreparationTime.text = "\(recipe.readyInMinutes ?? 0) min"
            recipeServings.text = "\(recipe.servings ?? 0) servs"
            recipeTitle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            
            imageRequest = ImageService.shared.getImage(rawUrl: recipe.largeImageURL) { [weak self] result in
                
                switch result {
                case .success(let image):
                    self?.imageLoadingIndicator.stopAnimating()
                    self?.recipeImage.image = image
                    UIView.animate(withDuration: 0.5) {
                        self?.recipeImage.alpha = 1
                    }
                case .failure(let error):
                    
                    print("fire from the recipe card")
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}
