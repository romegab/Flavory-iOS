
import UIKit

class StartedRecipeController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var startedRecipes: [ClippedRecipe] = [ClippedRecipe]()
    var selectedRecipe: ClippedRecipe?
    
    override func viewDidLoad() {
        
        tableView.separatorColor = UIColor.clear
                
        let recipeCellNib = UINib(nibName: "StartedRecipeCell", bundle: nil)
        tableView.register(recipeCellNib, forCellReuseIdentifier: "StartedRecipeCell")
        
        let loadedRecipes: [RecipeModel]? = DataManager.shared.getStartedRecipes()
        startedRecipes = processLoadedRecipies(loadedRecipies: loadedRecipes)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is RecipePreviewController {
            
            let vc = segue.destination as? RecipePreviewController
            
            if let recipe = selectedRecipe{
                vc?.recipe = recipe
            }
        }
    }
    
    private func processLoadedRecipies( loadedRecipies: [RecipeModel]? ) -> [ClippedRecipe] {
        var result: [ClippedRecipe] = [ClippedRecipe]()
        
        if let loadedRecipies = loadedRecipies{
            for rawRecipe in loadedRecipies {
                result.append(ClippedRecipe(loadedRecipe: rawRecipe))
            }
        }
        return result
    }
}

extension StartedRecipeController: UITableViewDelegate, UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      startedRecipes.count
  }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "StartedRecipeCell", for: indexPath) as! StartedRecipeCell
        let currentRecipe = startedRecipes[indexPath.row]
        cell.recipe = currentRecipe
      
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: indexPath, animated: true)

        selectedRecipe = startedRecipes[indexPath.row]
        performSegue(withIdentifier: "presentRecipePreview", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight:CGFloat = CGFloat()
        cellHeight = floor(UIScreen.main.bounds.width * 0.4)
        return cellHeight
    }
}

