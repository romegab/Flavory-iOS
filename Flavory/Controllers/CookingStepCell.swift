//
//  CookingStepCell.swift
//  Flavory
//
//  Created by Ivan Stoilov on 14.10.21.
//

import UIKit

class CookingStepCell: UITableViewCell, Checkable {
    
    @IBOutlet private weak var stepDescription: UILabel!
    @IBOutlet private weak var checkMark: UILabel!
    
    var isChecked: Bool = false {
        didSet {
            cookingStep?.isChecked.toggle()
            updateUI()
        }
    }
    
    var cookingStep: RecipeStep? {
        didSet {
            if cookingStep != nil {
                updateUI()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateUI() {
        if let cookingStep = cookingStep {
            stepDescription.text = cookingStep.step
            
            if cookingStep.isChecked {
                addBackground(color: UIColor.systemOrange)
            }
            else {
                addBackground(color: UIColor.white)
            }
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
    
    private func addBackground(color: UIColor) {
        self.backgroundColor = color.withAlphaComponent(0.5)
    }
}
