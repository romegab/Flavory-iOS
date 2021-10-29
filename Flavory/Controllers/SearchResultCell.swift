//
//  SearchResultCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 19.10.21.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    var recipe: ClippedRecipe? {
        didSet {
            updateUI()
        }
    }
    private var imageRequest: Cancellable?
    
    @IBOutlet fileprivate weak var recipeTitle: UILabel!
    @IBOutlet fileprivate weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpLook()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageRequest?.cancel()
    }
    
    private func setUpLook() {
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.frame
        self.backgroundView = blurEffectView
        recipeImage.layer.cornerRadius = 15
    }
    
    private func updateUI() {
        if let recipe = recipe {
            
            recipeTitle.text = recipe.title
            
            imageRequest = ImageService.shared.getImage(rawUrl: recipe.smallImageURL) { [weak self] result in
                
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
