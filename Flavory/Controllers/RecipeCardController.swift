//
//  CollectionViewCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 29.09.21.
//

import UIKit

class RecipeCardController: UICollectionViewCell {

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
    
    func updateUI(){
        
        recipeTitle.adjustsFontSizeToFitWidth = true
        recipePreparationTime.adjustsFontSizeToFitWidth = true
        recipeServings.adjustsFontSizeToFitWidth = true
        
        if let recipe = recipe{
            
            recipeTitle.text = recipe.title
            recipePreparationTime.text = "\(recipe.readyInMinutes ?? 0) min"
            recipeServings.text = "\(recipe.servings ?? 0) servs"
            recipeTitle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            
            recipeImage.image = UIImage(named: "Placeholder")
            if let smallURL = URL(string: recipe.imageURL) {
              downloadTask = recipeImage.loadImage(url: smallURL)
            }
        }
    }
}
