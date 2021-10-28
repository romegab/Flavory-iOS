//
//  StartedRecipeTableViewCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 26.10.21.
//

import UIKit

protocol StartedRecipeCellDelegate: AnyObject {
    
    func deleteCell(withRecipe recipe: inout ClippedRecipe)
    
    
}

class StartedRecipeCell: UITableViewCell {

    var recipe: ClippedRecipe? {
        didSet {
            updateUI()
        }
    }
    
    weak var delegate: StartedRecipeCellDelegate?
    
    private var imageRequest: Cancellable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        recipeImage.image = nil
        
        imageRequest?.cancel()
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeProgress: UILabel!
    @IBOutlet weak var background: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeProgress.backgroundColor = UIColor.green
        recipeImage.layer.cornerRadius = 10
        recipeProgress.layer.masksToBounds = true
        recipeProgress.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor.darkGray.cgColor

        // the shadow will be 5pt right and 5pt below the image view
        // negative value will place it on left / above of the image view
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)

        // how long the shadow will be. The longer the shadow, the more blurred it will be
        self.layer.shadowRadius = 4

        // opacity of the shadow
        self.layer.shadowOpacity = 0.2
        
        
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
            
            recipeProgress.text = String("\(recipe.progress)% done")
            if (0...25).contains(recipe.progress) {
                recipeProgress.backgroundColor = UIColor.init(named: "0-25green")
            } else if (26...50).contains(recipe.progress) {
                recipeProgress.backgroundColor = UIColor.init(named: "26-50green")
            } else if (51...75).contains(recipe.progress) {
                recipeProgress.backgroundColor = UIColor.init(named: "51-75green")
            } else if (76...100).contains(recipe.progress) {
                recipeProgress.backgroundColor = UIColor.init(named: "76-100green")
            }
            
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
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
     
        if var recipe = recipe {
            delegate?.deleteCell(withRecipe: &recipe)
        }
    }
}
