//
//  SearchResultCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 19.10.21.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet private weak var recipeTitle: UILabel!
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var imageRequest: Cancellable?
    
    var recipe: ClippedRecipe? {
        didSet {
            
            self.recipeImage.alpha = 0
            
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.startAnimating()
        setUpLook()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        recipeImage.image = nil
        
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
}
