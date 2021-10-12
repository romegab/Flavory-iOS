

import UIKit

class IngredientCell: UITableViewCell {
    
    private var imageRequest: Cancellable?
    
    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientDescription: UILabel!
    
    var ingredient: RecipeIngredient? {
        didSet {
            updateUI()
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
    
    private func updateUI() {
        if let ingredient = ingredient {
            imageRequest = ImageService.shared.getImage(rawUrl: ingredient.imageURL) { [weak self] result in
                
                switch result{
                case .success(let image):
                    self?.ingredientImage.image = image
                    self?.ingredientName.text = ingredient.name
                    self?.ingredientDescription.text = ingredient.original
                case .failure(let error):
                    print("fire from the ingredient cell card")
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}
