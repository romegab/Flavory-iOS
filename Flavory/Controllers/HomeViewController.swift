//
//  ViewController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 24.09.21.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var ResultTableView: UITableView!
    @IBOutlet weak var dailyMenuImage: UIImageView!
    @IBOutlet weak var lookUpForEatImage: UIImageView!
    @IBOutlet weak var collecitonView: UICollectionView!
    @IBOutlet weak var lookUpForEatText: UILabel!
    @IBOutlet weak var dailyMenuText: UILabel!
    
    let searchController = UISearchController()
    
    let search: Search = Search()
    var selectedRecipe: ClippedRecipe?
    var recipeInProgress: RecipeModel?
    var carouselRecipes = [ClippedRecipe]()
    var searchResult = [ClippedRecipe]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let applicationDocumentsDirectory: URL = {
          let paths = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)
          return paths[0]
        }()
        
        print(applicationDocumentsDirectory)
        
        let cellNib = UINib(nibName: "RecipeCardView" , bundle: nil)
        collecitonView.register(cellNib, forCellWithReuseIdentifier: "RecipeCard")
        
        let resultCellNib = UINib(nibName: "SearchResultCell" , bundle: nil)
        ResultTableView.register(resultCellNib, forCellReuseIdentifier: "SearchResultCell")
        
        ResultTableView.keyboardDismissMode = .onDrag
        ResultTableView.delegate = self
        resultView.backgroundColor = .clear
        // 2
        let blurEffect = UIBlurEffect(style: .light)
        // 3
        let blurView = UIVisualEffectView(effect: blurEffect)
        // 4
        blurView.translatesAutoresizingMaskIntoConstraints = false
        resultView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
          blurView.topAnchor.constraint(equalTo: resultView.topAnchor),
          blurView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
          blurView.heightAnchor.constraint(equalTo: resultView.heightAnchor),
          blurView.widthAnchor.constraint(equalTo: resultView.widthAnchor)
        ])
        
        adjustNavigationBar()
        loadCarouselContent()
        adjustBottomSection()
        
    }
    
    func adjustNavigationBar() {
        
        searchController.searchResultsUpdater = self
        searchController.view.backgroundColor = .clear
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for eat"
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func loadCarouselContent() {
        
        search.performRandomSearch(7) { [weak self] result in
            switch result{
            case .success(let recipes):
                let indexPath = IndexPath(item: 4, section: 0)
                self?.carouselRecipes = recipes
                DispatchQueue.main.async {
                    self?.collecitonView.reloadData()
                    self?.collecitonView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
                }
                case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    
        collecitonView.dataSource = self
        collecitonView.delegate = self
    }
    
    func adjustBottomSection() {
        dailyMenuImage.clipsToBounds = true
        dailyMenuImage.layer.masksToBounds = true
        dailyMenuImage.layer.cornerRadius = 7.5
        
        lookUpForEatImage.clipsToBounds = true
        lookUpForEatImage.layer.masksToBounds = true
        lookUpForEatImage.layer.cornerRadius = 7.5
        
        dailyMenuText.text = "GET\nYOUR\nDAILY\nMENU"
        dailyMenuText.adjustsFontSizeToFitWidth = true
        lookUpForEatText.text = "LOOK\nUP\nFOR\nEAT"
        lookUpForEatText.adjustsFontSizeToFitWidth = true
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
    
}

extension HomeViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return carouselRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecitonView.dequeueReusableCell(withReuseIdentifier: "RecipeCard", for: indexPath) as! RecipeCardController
        let searchResult = carouselRecipes[indexPath.row]
        
        cell.recipe = searchResult
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRecipe = carouselRecipes[indexPath.row]
        
        let loadedRecipe: RecipeModel? = DataManager.shared.getRecipeByID(id: selectedRecipe?.id ?? -1)
          if let loadedRecipe = loadedRecipe{
              selectedRecipe = ClippedRecipe(loadedRecipe: loadedRecipe)
        }
        
        performSegue(withIdentifier: "showRecipePreview", sender: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collecitonView.frame.width) * 0.6, height: collecitonView.frame.height)
    }
}

extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      
    search.performRecipeSearch(searchController.searchBar.text ?? "") { [weak self] result in

        switch result{
            case .success(let result):
              print(result)
            self?.searchResult = result
            self?.ResultTableView.reloadData()
            case .failure(let error):
              DispatchQueue.main.async {
                  print(error.localizedDescription)
              }
            }
        }
  }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      searchResult.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        let currentRecipe = searchResult[indexPath.row]
        cell.recipe = currentRecipe
        return cell
      
  }
  

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    tableView.deselectRow(at: indexPath, animated: true)
      
    let id: String = String(searchResult[indexPath.row].id)
      
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

extension HomeViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        resultView.isHidden = false
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.3) {
            self.resultView.alpha = 0
            self.ResultTableView.alpha = 0
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.resultView.alpha = 1
            self.ResultTableView.alpha = 1
        }
    }
}
