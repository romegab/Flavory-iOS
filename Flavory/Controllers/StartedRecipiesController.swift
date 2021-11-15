
import UIKit
import CoreData

class StartedRecipeController: UIViewController, NSFetchedResultsControllerDelegate, StartedRecipeCellDelegate {
    
    @IBOutlet private weak var editButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var viewTitle: UILabel!
    @IBOutlet weak var noRecipesLabel: UILabel!
    
    private var isInEditingMood: Bool = false {
        didSet {
            configureEditButton()
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
    
    private func configureEditButton(){
        if isInEditingMood {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        isInEditingMood.toggle()
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
}

