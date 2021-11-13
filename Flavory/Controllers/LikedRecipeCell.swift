//
//  LikedRecipeCellTableViewCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 13.11.21.
//

import UIKit

protocol LikedRecipeCellDelegate: AnyObject {
    
    func deleteCell(withLikedRecipe likedRecipe: RecipeLike)
    
}

class LikedRecipeCell: UITableViewCell {
    
    private var imageRequest: Cancellable?
    
    var likedRecipe: RecipeLike? {
        didSet {
            loadingIndicator.startAnimating()
            updateUI()
        }
    }
    
    weak var delegate: LikedRecipeCellDelegate?
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        recipeImage.image = nil
        
        imageRequest?.cancel()
    }
    
    private func updateUI() {
        if let likedRecipe = likedRecipe {
            recipeTitle.text = likedRecipe.recipeName
            
            imageRequest = ImageService.shared.getImage(rawUrl: likedRecipe.imageURL ?? "") { [weak self] result in
                
                switch result{
                case .success(let image):
                    self?.loadingIndicator.stopAnimating()
                    self?.recipeImage.image = image
                    UIView.animate(withDuration: 0.5) {
                        self?.recipeImage.alpha = 1
                    }
                case .failure(let error):
                    print("fire from the ingredient cell card")
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        if let likedRecipe = likedRecipe {
            delegate?.deleteCell(withLikedRecipe: likedRecipe)
        }
    }
}
