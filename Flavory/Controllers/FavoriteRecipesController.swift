//
//  FavoriteRecipesController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 13.11.21.
//

import UIKit
import CoreData

class FavoriteRecipesController: UIViewController, NSFetchedResultsControllerDelegate, LikedRecipeCellDelegate {
    
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
    
    @IBOutlet weak var tableView: UITableView!
    
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
}
