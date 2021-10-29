//
//  CollectionViewCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 29.09.21.
//

import UIKit

class RecipeCardController: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var recipeImage: UIImageView!
    @IBOutlet fileprivate weak var recipeTitle: UILabel!
    @IBOutlet fileprivate weak var background: UIView!
    @IBOutlet fileprivate weak var recipePreparationTime: UILabel!
    @IBOutlet fileprivate weak var recipeServings: UILabel!
    
    private var imageRequest: Cancellable?
    
    var recipe: ClippedRecipe? {
        didSet{
            updateUI()
        }
    }
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    func updateUI() {
        
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
                    self?.recipeImage.image = image
                case .failure(let error):
                    
                    print("fire from the recipe card")
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}
