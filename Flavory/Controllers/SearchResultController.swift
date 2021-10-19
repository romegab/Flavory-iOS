//
//  SearchResultViewViewController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 19.10.21.
//

import UIKit

class SearchResultController: UIViewController {

    var searchResult: ResultArray = ResultArray() {
        didSet {
            searchResultTable.reloadData()
        }
    }
    
    @IBOutlet weak var searchResultTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ingredientCellNib = UINib(nibName: "SearchResultCell", bundle: nil)
        searchResultTable.register(ingredientCellNib, forCellReuseIdentifier: "SearchResultCell")
        
    }
}

// MARK: - Table View Delegate
extension SearchResultController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      return searchResult.results?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
      let currentRecipe = searchResult.results?[indexPath.row]
      cell.recipe = currentRecipe
      return cell
      
  }
  

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if var cell: Checkable = tableView.cellForRow(at: indexPath) as? Checkable{
          cell.isChecked.toggle()
          tableView.deselectRow(at: indexPath, animated: true)
    }
  }
}

