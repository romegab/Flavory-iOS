//
//  CollectionViewCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 29.09.21.
//

import UIKit

class RecipeCardController: UICollectionViewCell {

    private var imageRequest: Cancellable?
    
    var recipe: ClippedRecipe?{
        didSet{
            updateUI()
        }
    }
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var recipePreparationTime: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var recipeServings: UILabel!
    
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
        
        recipeImage.image = nil
        
        imageRequest?.cancel()
    }
    
    func updateUI(){
        
        recipeTitle.adjustsFontSizeToFitWidth = true
        recipePreparationTime.adjustsFontSizeToFitWidth = true
        recipeServings.adjustsFontSizeToFitWidth = true
        
        if let recipe = recipe{
            
            recipeTitle.text = recipe.title
            recipePreparationTime.text = "\(recipe.readyInMinutes) min"
            recipeServings.text = "\(recipe.servings ?? 0) servs"
            recipeTitle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            
            recipeImage.image = UIImage(named: "Placeholder")
            
            imageRequest = ImageService.shared.getImage(rawUrl: recipe.imageURL) { [weak self] result in
                
                switch result{
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
