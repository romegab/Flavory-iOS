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
    
    @IBOutlet weak var chooseIngredientsView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cousinePicker: UIPickerView!
    @IBOutlet weak var chooseIngredinetsImage: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dishType: UIView!
    
    private var cuisines: [String] = ["American", "British", "Chinesse", " Easter EU", "French", "German", "Greek", "Indian", "Italian", "Mediterian", "Spanish"]
    private var mealTypes: [String] = ["Main course", "Side dish", "Dessert", "Salad", "Breakfast", "Soup", "Snack", "Drink"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBlurredBackground()
        pickerView.setValue(UIColor.white, forKey: "textColor")
        cousinePicker.setValue(UIColor.white, forKey: "textColor")
        
        chooseIngredinetsImage.clipsToBounds = true

        chooseIngredinetsImage.layer.cornerRadius = 15
        filterButton.layer.cornerRadius = 15
        
        carbsView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        carbsView.layer.cornerRadius = 15
        
        kcalView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        kcalView.layer.cornerRadius = 15
        
        proteinView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        proteinView.layer.cornerRadius = 15
        
        fatView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        fatView.layer.cornerRadius = 15
        
        dishType.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        dishType.layer.cornerRadius = 15
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        cousinePicker.delegate = self
        cousinePicker.dataSource = self
        
        proteinSlider.translatesAutoresizingMaskIntoConstraints = false
        fatSlider.translatesAutoresizingMaskIntoConstraints = false
        kcalSlider.translatesAutoresizingMaskIntoConstraints = false
        carbsSlider.translatesAutoresizingMaskIntoConstraints = false
        
        carbsView.addSubview(carbsSlider)
        kcalView.addSubview(kcalSlider)
        fatView.addSubview(fatSlider)
        proteinView.addSubview(proteinSlider)
        
        pickerView.selectRow(3, inComponent: 0, animated: false)
        cousinePicker.selectRow(3, inComponent: 0, animated: false)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let margin: CGFloat = 50
        let width = carbsView.bounds.width - 2 * margin
        let height: CGFloat = 30
      
        carbsSlider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        carbsSlider.center = carbsView.convert(carbsView.center, from: carbsView.superview)
        carbsSlider.center.y += 20
        carbsSlider.addTarget(self, action: #selector(carbsSliderValueChanged(_:)), for: .valueChanged)
        
        kcalSlider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        kcalSlider.updateLayerFrames()
        kcalSlider.center = kcalView.convert(kcalView.center, from:kcalView.superview)
        kcalSlider.center.y += 15
        kcalSlider.addTarget(self, action: #selector(kcalSliderValueChanged(_:)), for: .valueChanged)

        fatSlider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        fatSlider.updateLayerFrames()
        fatSlider.center = fatView.convert(fatView.center, from:fatView.superview)
        fatSlider.center.y += 15
        fatSlider.addTarget(self, action: #selector(fatSliderValueChanged(_:)), for: .valueChanged)
        
        proteinSlider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        proteinSlider.updateLayerFrames()
        proteinSlider.center = proteinView.convert(proteinView.center, from: proteinView.superview)
        proteinSlider.center.y += 15
        proteinSlider.addTarget(self, action: #selector(proteinSliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func carbsSliderValueChanged(_ carbsSlider: RangeSlider) {
        minCarbs.text = "min carbs: \(String(format: "%.0f", ceil(carbsSlider.lowerValue * 500)))"
        maxCarbs.text = "max carbs: \(String(format: "%.0f", ceil(carbsSlider.upperValue * 500)))"
    }
    @objc func kcalSliderValueChanged(_ carbsSlider: RangeSlider) {
        minKcal.text = "min kcal: \(String(format: "%.0f", ceil(kcalSlider.lowerValue * 500)))"
        maxKcal.text = "max kcal: \(String(format: "%.0f", ceil(kcalSlider.upperValue * 500)))"
    }
    @objc func proteinSliderValueChanged(_ carbsSlider: RangeSlider) {
        minProtein.text = "min protein: \(String(format: "%.0f", ceil(proteinSlider.lowerValue * 500)))"
        maxProtein.text = "max protein: \(String(format: "%.0f", ceil(proteinSlider.upperValue * 500)))"
    }
    @objc func fatSliderValueChanged(_ carbsSlider: RangeSlider) {
        minFat.text = "min fat: \(String(format: "%.0f", ceil(fatSlider.lowerValue * 500)))"
        maxFat.text = "max fat: \(String(format: "%.0f", ceil(fatSlider.upperValue * 500)))"
    }
    
    private func setBlurredBackground() {
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension FilterSearchContorller: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return cuisines.count
        } else {
            return mealTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return cuisines[row]
        } else {
            return mealTypes[row]
        }
    }
}
