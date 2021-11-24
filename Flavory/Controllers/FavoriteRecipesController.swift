//
//  FavoriteRecipesController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 13.11.21.
//

import UIKit
import CoreData

class FavoriteRecipesController: UIViewController, NSFetchedResultsControllerDelegate, LikedRecipeCellDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultsLabel: UILabel!
    
    private var likedRecipes: [RecipeLike]?
    private var selectedRecipe: ClippedRecipe?
    private let search: Search = Search()
    private lazy var fetchedResultsController: NSFetchedResultsController<RecipeLike> = {
        
        let fetchRequest: NSFetchRequest<RecipeLike> = RecipeLike.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        let recipeCellNib = UINib(nibName: "LikedRecipeCell", bundle: nil)
        tableView.register(recipeCellNib, forCellReuseIdentifier: "LikedRecipeCell")
        

        tableView.delegate = self
        tableView.dataSource = self
        fetchedResultsController.delegate = self
        tableView.reloadData()
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let vc = segue.destination as? RecipePreviewController
        
        if let recipe = selectedRecipe{
            vc?.recipe = recipe
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func deleteCell(withLikedRecipe likedRecipe: RecipeLike) {
        DataManager.shared.deleteRecipeLike(id: likedRecipe.id)
    }
}

extension FavoriteRecipesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController.fetchedObjects?.count ?? 0 == 0 {
            noResultsLabel.alpha = 1
        } else {
            noResultsLabel.alpha = 0
        }
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedRecipeCell", for: indexPath) as! LikedRecipeCell
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            let currentRecipe = fetchedObjects[indexPath.row]
            cell.likedRecipe = currentRecipe
            cell.delegate = self
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let id: String = String(fetchedResultsController.object(at: indexPath).id)

        let loadedRecipe: RecipeModel? = DataManager.shared.getRecipeByID(id: Int(id) ?? -1)
        if let loadedRecipe = loadedRecipe{
            selectedRecipe = ClippedRecipe(loadedRecipe: loadedRecipe)
            performSegue(withIdentifier: "showRecipePreview", sender: nil)
        }
        
        else{
            var currentRecipe: ClippedRecipe?
            
            search.performSearchByID(id) { [weak self] result in
                switch result{
                case .success(let recipe):
                    currentRecipe = recipe
                    self?.selectedRecipe = currentRecipe
                    DispatchQueue.main.async {
                        self?.performSegue(withIdentifier: "showRecipePreview", sender: nil)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }
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
            
            let cell = tableView.cellForRow(at: indexPath) as! LikedRecipeCell
            
            if let recipe = cell.likedRecipe {
                self?.deleteCell(withLikedRecipe: recipe)
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
