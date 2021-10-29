

import UIKit

class IngredientCell: UITableViewCell, Checkable {
    
    var isChecked: Bool = false {
        didSet {
            ingredient?.isChecked.toggle()
            configureCheckmark()
        }
    }
    
    private var imageRequest: Cancellable?
    
    @IBOutlet fileprivate weak var ingredientImage: UIImageView!
    @IBOutlet fileprivate weak var ingredientName: UILabel!
    @IBOutlet fileprivate weak var ingredientDescription: UILabel!
    @IBOutlet fileprivate weak var checkMark: UILabel!
    
    var ingredient: RecipeIngredient? {
        didSet {
            updateUI()
            configureCheckmark()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
            
            imageRequest = ImageService.shared.getImage(rawUrl: ingredient.imageURL) { [weak self] result in
                
                switch result{
                case .success(let image):
                    self?.ingredientImage.image = image
                case .failure(let error):
                    print("fire from the ingredient cell card")
                    print(error.localizedDescription)
                }
            }
        }
    }
}
