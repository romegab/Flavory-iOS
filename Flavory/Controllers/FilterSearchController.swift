//
//  FilterSearchController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 3.11.21.
//

import UIKit

class FilterSearchContorller: UIViewController {
    
    let carbsSlider = RangeSlider(frame: .zero)
    let kcalSlider = RangeSlider(frame: .zero)
    let fatSlider = RangeSlider(frame: .zero)
    let proteinSlider = RangeSlider(frame: .zero)
    
    @IBOutlet weak var carbsView: UIView!
    @IBOutlet weak var maxCarbs: UILabel!
    @IBOutlet weak var minCarbs: UILabel!
    
    @IBOutlet weak var kcalView: UIView!
    @IBOutlet weak var minKcal: UILabel!
    @IBOutlet weak var maxKcal: UILabel!
    
    @IBOutlet weak var fatView: UIView!
    @IBOutlet weak var minFat: UILabel!
    @IBOutlet weak var maxFat: UILabel!
    
    @IBOutlet weak var proteinView: UIView!
    @IBOutlet weak var minProtein: UILabel!
    @IBOutlet weak var maxProtein: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        carbsView.addSubview(carbsSlider)
        kcalView.addSubview(kcalSlider)
        fatView.addSubview(fatSlider)
        proteinView.addSubview(proteinSlider)
        
        proteinSlider.translatesAutoresizingMaskIntoConstraints = false
        fatSlider.translatesAutoresizingMaskIntoConstraints = false
        kcalSlider.translatesAutoresizingMaskIntoConstraints = false
        carbsSlider.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        
        let margin: CGFloat = 50
        let width = carbsView.bounds.width - 2 * margin
        let height: CGFloat = 30
      
        carbsSlider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        carbsSlider.center = carbsView.convert(carbsView.center, from:carbsView.superview)
        carbsSlider.center.y += 15
        
        kcalSlider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        kcalSlider.center = kcalView.convert(kcalView.center, from:kcalView.superview)
        kcalSlider.center.y += 15

        fatSlider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        fatSlider.center = fatView.convert(fatView.center, from:fatView.superview)
        fatSlider.center.y += 15
        
        proteinSlider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        proteinSlider.center = proteinView.convert(proteinView.center, from:proteinView.superview)
        proteinSlider.center.y += 15
    }
    
    @objc func carbsSliderValueChanged(_ carbsSlider: RangeSlider) {
      let values = "(\(carbsSlider.lowerValue) \(carbsSlider.upperValue))"
      print("Range slider value changed: \(values)")
    }
}
