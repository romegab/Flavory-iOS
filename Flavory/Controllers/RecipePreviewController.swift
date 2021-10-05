//
//  RecipePreviewController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 4.10.21.
//

import UIKit

class RecipePreviewController: UIViewController {
    
    var recipe: ClippedRecipe?
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        //close button setup
        closeButton.layer.cornerRadius = 30
        closeButton.layer.masksToBounds = false
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        
        if UITraitCollection.current.userInterfaceStyle == .dark {
            closeButton.backgroundColor = UIColor.black
            closeButton.tintColor = UIColor.white
        }
        else {
            
            closeButton.backgroundColor = UIColor.white
            closeButton.tintColor = UIColor.black
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}



