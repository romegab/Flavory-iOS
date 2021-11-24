
import UIKit
import CoreData

class StartedRecipeController: UIViewController, NSFetchedResultsControllerDelegate, StartedRecipeCellDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var viewTitle: UILabel!
    @IBOutlet weak var noRecipesLabel: UILabel!
    
    private var isInEditingMood: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<RecipeModel> = {
        
        let fetchRequest: NSFetchRequest<RecipeModel> = RecipeModel.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "isInProgress = %isInProgress", true
        )
        
        let sortDescriptor = NSSortDescriptor(key: "progress", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    var selectedRecipe: ClippedRecipe?
    
    override func viewDidLoad() {
        fetchedResultsController.delegate = self
        
        tableView.separatorColor = UIColor.clear
        
        let recipeCellNib = UINib(nibName: "StartedRecipeCell", bundle: nil)
        tableView.register(recipeCellNib, forCellReuseIdentifier: "StartedRecipeCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        isInEditingMood = false
        
        if segue.destination is RecipePreviewController {
            
            let vc = segue.destination as? RecipePreviewController
            
            if let recipe = selectedRecipe{
                vc?.recipe = recipe
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func deleteCell(withRecipe recipe: inout ClippedRecipe) {
        recipe.isInProgress.toggle()
        for currentIngredient in recipe.extendedIngredients ?? [] {
            currentIngredient.isChecked = false
        }
        
        for currentStep in recipe.steps ?? [] {
            currentStep.isChecked = false
        }
        DataManager.shared.updateRecipe(recipe)
    }
    
}

extension StartedRecipeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController.fetchedObjects?.count == 0 {
            noRecipesLabel.alpha = 1
        }
        else {
            noRecipesLabel.alpha = 0
        }
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StartedRecipeCell", for: indexPath) as! StartedRecipeCell
        let currentRecipe = ClippedRecipe(loadedRecipe: fetchedResultsController.object(at: indexPath))
        cell.recipe = currentRecipe
        cell.delegate = self
        
        cell.deleteButton.isHidden = !isInEditingMood
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedRecipe = ClippedRecipe(loadedRecipe: fetchedResultsController.object(at: indexPath))
        performSegue(withIdentifier: "presentRecipePreview", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight:CGFloat = CGFloat()
        cellHeight = floor(UIScreen.main.bounds.width * 0.3)
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var actions = [UIContextualAction]()

        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in

            let cell = tableView.cellForRow(at: indexPath) as! StartedRecipeCell
            
            if var recipe = cell.recipe {
                self?.deleteCell(withRecipe: &recipe)
            }

            completion(true)
        }

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold, scale: .large)
        delete.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        delete.backgroundColor = .white

        actions.append(delete)

        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = false

        return config
    }
}

extension UIImage {

    func addBackgroundCircle(_ color: UIColor?) -> UIImage? {

        let circleDiameter = max(size.width * 2, size.height * 2)
        let circleRadius = circleDiameter * 0.5
        let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(x: circleRadius - (size.width * 0.5), y: circleRadius - (size.height * 0.5), width: size.width, height: size.height)

        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? .systemRed
        view.layer.cornerRadius = circleDiameter * 0.5

        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)

        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { ctx in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }

        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}
