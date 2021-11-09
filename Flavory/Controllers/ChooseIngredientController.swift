//
//  ChooseIngredientController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 4.11.21.
//

import UIKit

protocol ChooseIngredientControlerDelegate: AnyObject {
    func reciveIngredients(ingredints: [RecipeIngredient])
}

class ChooseIngredientController: UIViewController {
    
    weak var delegate: ChooseIngredientControlerDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    private var choosedIngredients: [RecipeIngredient] = [RecipeIngredient]()
    private var currentIngredients: [RecipeIngredient] = [RecipeIngredient]()
    private let search: Search = Search()
    private var isSearchTrothelled: Bool = false
    private var currentSegmentIndex = 2
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var infoDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        setDelegates()
        
        let ingredientCellNib = UINib(nibName: "IngredientCell", bundle: nil)
        tableView.register(ingredientCellNib, forCellReuseIdentifier: "IngredientCell")
    }
    
    private func setDelegates() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.placeholder = "Search Ingredients"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func performSearch(query: String?) {
        search.performIngredientSearch(query: query ?? "") { [weak self] result in
            switch result{
            case .success(let result):
                print(result)
                self?.currentIngredients = result
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressd(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if currentSegmentIndex == 2 {
            if let delegate = delegate {
                delegate.reciveIngredients(ingredints: choosedIngredients)
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
            currentSegmentIndex = 2
            tableView.reloadData()
        }
    }
}
extension ChooseIngredientController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if !isSearchTrothelled{
            isSearchTrothelled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.performSearch(query: searchController.searchBar.text)
                self.isSearchTrothelled = false
            }
        }
    }
}

extension ChooseIngredientController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noResultsLabel.text = "No ingredients are searched"
        infoDescriptionLabel.text = "Searched Ingredients"
        if currentSegmentIndex == 1 {
            if currentIngredients.count != 0 {
                noResultsView.alpha = 0
            } else {
                noResultsView.alpha = 1
            }
            return currentIngredients.count
        } else {
            infoDescriptionLabel.text = "Selected Ingredients"

            noResultsLabel.text = "No ingredients are selected"
            if choosedIngredients.count != 0 {
                noResultsView.alpha = 0
            } else {
                noResultsView.alpha = 1
            }
            return choosedIngredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
            var currentIngredient = currentIngredients[indexPath.row]
            if choosedIngredients.contains(where: { $0.id == currentIngredient.id}) {
                currentIngredient = choosedIngredients.first(where: {$0.id == currentIngredient.id}) ?? currentIngredient
            }
            cell.ingredient = currentIngredient
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
            let currentIngredient = choosedIngredients[indexPath.row]
            cell.ingredient = currentIngredient
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentSegmentIndex == 1 {
            if let cell: IngredientCell = tableView.cellForRow(at: indexPath) as? IngredientCell{
                
                cell.isChecked.toggle()
                
                if !cell.ingredient!.isChecked {
                    choosedIngredients = choosedIngredients.filter(){$0.id != cell.ingredient?.id}
                } else {
                    choosedIngredients.append(cell.ingredient!)
                }
                
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } else {
            if let cell: IngredientCell = tableView.cellForRow(at: indexPath) as? IngredientCell{
                cell.isChecked.toggle()
                tableView.deselectRow(at: indexPath, animated: true)
                choosedIngredients = choosedIngredients.filter(){$0.id != cell.ingredient?.id}
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension ChooseIngredientController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        currentSegmentIndex = 1
        tableView.reloadData()
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentSegmentIndex = 2
        tableView.reloadData()
    }
    
}
