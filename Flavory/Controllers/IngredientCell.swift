

import UIKit

class IngredientCell: UITableViewCell, Checkable {
    
    @IBOutlet private weak var ingredientImage: UIImageView!
    @IBOutlet private weak var ingredientName: UILabel!
    @IBOutlet private weak var ingredientDescription: UILabel!
    @IBOutlet private weak var checkMark: UILabel!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    private var imageRequest: Cancellable?
    
    var isChecked: Bool = false {
        didSet {
            ingredient?.isChecked.toggle()
            configureCheckmark()
        }
    }
    
    var ingredient: RecipeIngredient? {
        didSet {
            updateUI()
            imageLoadingIndicator.startAnimating()
            configureCheckmark()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageLoadingIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ingredientImage.image = nil
        
        imageRequest?.cancel()
    }
    
    private func configureCheckmark() {
        if let ingredient = ingredient {
            if ingredient.isChecked {
                checkMark.text = "✓"
            }
            else {
                checkMark.text = ""
            }
        }
    }
    
    private func updateUI() {
        if let ingredient = ingredient {
            ingredientName.text = ingredient.name
            ingredientDescription.text = ingredient.original
            
            imageRequest = ImageService.shared.getImage(rawUrl: ingredient.imageURL, id: ingredient.id ?? 0) { [weak self] result in
                
                switch result{
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.imageLoadingIndicator.stopAnimating()
                        self?.ingredientImage.image = image
                        UIView.animate(withDuration: 0.5) {
                            self?.imageLoadingIndicator.stopAnimating()
                            self?.imageLoadingIndicator.alpha = 0
                            self?.ingredientImage .alpha = 1
                            self?.ingredientImage.clipsToBounds = true
                            self?.ingredientImage.layer.masksToBounds = true
                            self?.ingredientImage.layer.cornerRadius = 15
                        }
                    }
                case .failure(let error):
                    print("fire from the ingredient cell card")
                    print(error.localizedDescription)
                }
            }
        }
    }
}
