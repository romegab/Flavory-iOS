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
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuIndexesView: UIView!
    @IBOutlet weak var getNewMenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "RecipeCardView" , bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "RecipeCard")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpMenuIndexes()
        
        loadDailyMenu()
        
    }
    
    private func loadDailyMenu() {
        search.performMenuSearch() { [weak self] result in
            switch result{
            case .success(let recipes):
                self?.menu = recipes
                DispatchQueue.main.async {
                    print("in the candy shop tu tu tu tu")
                    self?.showCurrentRecipe()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func showCurrentRecipe() {
        let selectedIndex = segmentControl.selectedSegmentIndex
        currentRecipe = menu[selectedIndex]
        
        collectionView.reloadData()
    }
    
    private func setUpMenuIndexes() {
        menuIndexesView.layer.cornerRadius = 15
        getNewMenuButton.layer.cornerRadius = 15
    }
    
    @IBAction func segmentCotrolChanged(_ sender: UISegmentedControl) {
        showCurrentRecipe()
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
        
//        selectedRecipe = carouselRecipes[indexPath.row]
//        let loadedRecipe: RecipeModel? = DataManager.shared.getRecipeByID(id: selectedRecipe?.id ?? -1)
//        if let loadedRecipe = loadedRecipe{
//            selectedRecipe = ClippedRecipe(loadedRecipe: loadedRecipe)
//        }
//        performSegue(withIdentifier: "showRecipePreview", sender: nil)
    }
}

extension DailyMenuController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.width)
        print(collectionView.frame.height)
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)

    }
}

