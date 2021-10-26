//
//  StartedRecipeTableViewCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 26.10.21.
//

import UIKit

class StartedRecipeCell: UITableViewCell {

    var recipe: ClippedRecipe? {
        didSet {
            updateUI()
        }
    }
    private var imageRequest: Cancellable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        recipeImage.image = nil
        
        imageRequest?.cancel()
    }
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeProgress: UILabel!
    @IBOutlet weak var background: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        recipeImage.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor.black.cgColor

        // the shadow will be 5pt right and 5pt below the image view
        // negative value will place it on left / above of the image view
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)

        // how long the shadow will be. The longer the shadow, the more blurred it will be
        self.layer.shadowRadius = 4

        // opacity of the shadow
        self.layer.shadowOpacity = 0.5
        
        
        background.layer.cornerRadius = 10
      
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateUI() {
        if let recipe = recipe {
            
            recipeTitle.text = recipe.title
            
            imageRequest = ImageService.shared.getImage(rawUrl: recipe.largeImageURL) { [weak self] result in
                switch result{
                case .success(let image):
                    self?.recipeImage.image = image
                case .failure(let error):
                    print("fire from the ingredient cell card")
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}
