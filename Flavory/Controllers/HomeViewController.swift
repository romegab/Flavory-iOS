//
//  ViewController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 24.09.21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var dailyMenuImage: UIImageView!
    @IBOutlet weak var lookUpForEat: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchFilterButton: UIButton!
    @IBOutlet weak var collecitonView: UICollectionView!
    
    let search: Search = Search()
    var searchResults = [ClippedRecipe]()
    let queue = DispatchQueue.global()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let cellNib = UINib(nibName: "RecipeCardView" , bundle: nil)
        collecitonView.register(cellNib, forCellWithReuseIdentifier: "RecipeCard")
        
            search.performRandomSearch(7) { result in
                switch result{
                case .success(let recipies):
                    self.searchResults = recipies
                    self.collecitonView.reloadData()
                    let indexPath = IndexPath(item: 4, section: 0)
                    self.collecitonView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        
        collecitonView.dataSource = self
        collecitonView.delegate = self

        dailyMenuImage.clipsToBounds = true
        dailyMenuImage.layer.masksToBounds = true
        dailyMenuImage.layer.cornerRadius = 5
        //dailyMenuImage.layer.masksToBounds = true
        //dailyMenuImage.clipsToBounds = true
        lookUpForEat.clipsToBounds = true
        lookUpForEat.layer.masksToBounds = true
        lookUpForEat.layer.cornerRadius = 5
        lookUpForEat.clipsToBounds = true
        lookUpForEat.layer.masksToBounds = true
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension HomeViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return searchResults.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecitonView.dequeueReusableCell(withReuseIdentifier: "RecipeCard", for: indexPath) as! RecipeCardController
        let searchResult = searchResults[indexPath.row]
        cell.recipe = searchResult
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collecitonView.frame.width) * 0.6, height: collecitonView.frame.height)
    }
}

