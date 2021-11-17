import UIKit

protocol LikedRecipeCellDelegate: AnyObject {
    
    func deleteCell(withLikedRecipe likedRecipe: RecipeLike)
    
}

class LikedRecipeCell: UITableViewCell {

    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var recipeTitle: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    private var imageRequest: Cancellable?
    
    weak var delegate: LikedRecipeCellDelegate?
    
    var likedRecipe: RecipeLike? {
        didSet {
            loadingIndicator.startAnimating()
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
