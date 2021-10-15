//
//  CookingStepCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 14.10.21.
//

import UIKit

class CookingStepCell: UITableViewCell, Checkable {
    
    var isChecked: Bool = false
    {
        didSet {
            cookingStep?.isChecked = isChecked
            configureCheckmark()
            if isChecked {
                addBackground(color: UIColor.systemOrange)
            }
            else {
                addBackground(color: UIColor.white)
            }
        }
    }
    
    @IBOutlet weak var stepDescription: UILabel!
    @IBOutlet weak var checkMark: UILabel!
    
    var cookingStep: RecipeStep? {
        
        didSet {
            if cookingStep != nil {
                updateUI()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateUI() {
        if let cookingStep = cookingStep {
            stepDescription.text = cookingStep.step
        }
        configureCheckmark()
    }
    
    private func configureCheckmark() {
        if let cookingStep = cookingStep {
            if cookingStep.isChecked {
                checkMark.text = "✓"
            }
            else {
                checkMark.text = ""
            }
        }
    }
    
    private func addBackground(color: UIColor)
    {
        self.backgroundColor = color.withAlphaComponent(0.5)
    }
}
