//
//  DailyMenuController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 29.10.21.
//
import UIKit

class DailyMenuController: UIViewController {
    private let search: Search = Search()
    private var menu: [ClippedRecipe] = [ClippedRecipe]()
    private var currentRecipe: ClippedRecipe?
    private var selectedRecipe: ClippedRecipe?
    private var menuNutritients: MenuNutrients = MenuNutrients()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuIndexesView: UIView!
    @IBOutlet weak var getNewMenuButton: UIButton!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "RecipeCardView" , bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "RecipeCard")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpMenuIndexes()
        
        loadDailyMenu()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? RecipePreviewController
            
        if let recipe = selectedRecipe{
            vc?.recipe = recipe
        }
    }
    
    private func loadDailyMenu() {
        
        if let loadedMenu = DataManager.shared.getDailyMenu() {
            var loadedMenuRecipes = [ClippedRecipe]()
            var currentMenuNutritients = MenuNutrients()
            
            currentMenuNutritients.protein = Double(loadedMenu.protein)
            currentMenuNutritients.fat = Double(loadedMenu.fat)
            currentMenuNutritients.carbohydrates = Double(loadedMenu.carbohydrates)
            currentMenuNutritients.calories = Double(loadedMenu.calories)
            
            menuNutritients = currentMenuNutritients
            
            if let loadedRecipes = loadedMenu.recipes{
                for rawRecipes in loadedRecipes {
                    loadedMenuRecipes.append(ClippedRecipe(loadedRecipe: rawRecipes))
                }
                menu = loadedMenuRecipes
            }
             
            loadMenuNutritients()
            showCurrentRecipe()
            
            
        }else {
            search.performMenuSearch() { [weak self] result in
                switch result{
                case .success(let recipes):
                    self?.menu = recipes.0
                    self?.menuNutritients = recipes.1
                    DataManager.shared.saveMenu(self!.menu, nutrients: self!.menuNutritients)
                    DispatchQueue.main.async {
                        self?.loadMenuNutritients()
                        self?.showCurrentRecipe()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showCurrentRecipe() {
        let selectedIndex = segmentControl.selectedSegmentIndex
        if menu.count == 3 {
            currentRecipe = menu[selectedIndex]
        }
        
        collectionView.reloadData()
    }
    
    private func setUpMenuIndexes() {
        menuIndexesView.layer.cornerRadius = 15
        getNewMenuButton.layer.cornerRadius = 15
    }
    
    private func loadMenuNutritients() {
        caloriesLabel.text = String(Int(menuNutritients.calories ?? 0))
        proteinLabel.text = String(Int(menuNutritients.protein ?? 0))
        fatLabel.text = String(Int(menuNutritients.fat ?? 0))
        carbohydratesLabel.text = String(Int(menuNutritients.carbohydrates ?? 0))
    }
    
    @IBAction func segmentCotrolChanged(_ sender: UISegmentedControl) {
        showCurrentRecipe()
    }
    
    @IBAction func backButtonClikced(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getNewMenuButtonClicked(_ sender: UIButton) {
        
        DataManager.shared.removeDailyMenu()
        
        search.performMenuSearch() { [weak self] result in
            switch result{
            case .success(let recipes):
                self?.menu = recipes.0
                self?.menuNutritients = recipes.1
                
                DataManager.shared.saveMenu(self!.menu, nutrients: self!.menuNutritients)
                DispatchQueue.main.async {
                    self?.loadMenuNutritients()
                    self?.showCurrentRecipe()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
        
        loadDailyMenu()
    }
    
}

extension DailyMenuController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCard", for: indexPath) as! RecipeCardController
        cell.recipe = currentRecipe
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        search.performSearchByID(String(currentRecipe?.id ?? -1)) { [weak self] result in
            switch result{
            case .success(let recipe):
                self?.selectedRecipe = recipe
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

extension DailyMenuController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.width)
        print(collectionView.frame.height)
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
}

