//
//  FilterSearchController.swift
//  Flavory
//
//  Created by Ivan Stoilov on 3.11.21.
//

import UIKit

protocol FilterSearchControllerDelegate: AnyObject {
    func loadFilters(filters: FilterSet)
}

class FilterSearchContorller: UIViewController, ChooseIngredientControlerDelegate {
    // Custom UI Elements
    let carbsSlider = RangeSlider(frame: .zero)
    let kcalSlider = RangeSlider(frame: .zero)
    let fatSlider = RangeSlider(frame: .zero)
    let proteinSlider = RangeSlider(frame: .zero)
    
    @IBOutlet private weak var carbsView: UIView!
    @IBOutlet private weak var maxCarbs: UILabel!
    @IBOutlet private weak var minCarbs: UILabel!

    @IBOutlet private weak var kcalView: UIView!
    @IBOutlet private weak var minKcal: UILabel!
    @IBOutlet private weak var maxKcal: UILabel!

    @IBOutlet private weak var fatView: UIView!
    @IBOutlet private weak var minFat: UILabel!
    @IBOutlet private weak var maxFat: UILabel!

    @IBOutlet private weak var proteinView: UIView!
    @IBOutlet private weak var minProtein: UILabel!
    @IBOutlet private weak var maxProtein: UILabel!
    
    @IBOutlet private weak var chooseIngredientsView: UIView!
    @IBOutlet private weak var mealTypePicker: UIPickerView!
    @IBOutlet private weak var cuisinePicker: UIPickerView!
    @IBOutlet private weak var chooseIngredinetsImage: UIImageView!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var dishType: UIView!
    
    private var cuisines: [String] = ["All", "American", "British", "Chinesse", " Easter EU", "French", "German", "Greek", "Indian", "Italian", "Mediterian", "Spanish"]
    private var mealTypes: [String] = ["All", "Main course", "Side dish", "Dessert", "Salad", "Breakfast", "Soup", "Snack", "Drink"]
    
    private var choosedIngredients: [RecipeIngredient] = [RecipeIngredient]()
    weak var delegate: FilterSearchControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBlurredBackground()
        setupPickers()
        setupSliders()
        
        chooseIngredinetsImage.clipsToBounds = true
        chooseIngredinetsImage.layer.cornerRadius = 15
        
        filterButton.layer.cornerRadius = 15
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setSlidersLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChooseIngredientView" {
            let navVc = segue.destination as? UINavigationController
            let vc = navVc?.viewControllers.first as! ChooseIngredientController
            vc.choosedIngredients = choosedIngredients
            vc.delegate = self
        }
    }
    
    @objc func carbsSliderValueChanged(_ carbsSlider: RangeSlider) {
        var minValue = carbsSlider.lowerValue * 500 - 20
        var maxValue = carbsSlider.upperValue * 500 + 20
        
        if minValue < 0 {
            minValue = 0
        }
        
        if maxValue > 500 {
            maxValue = 500
        }
        
        minCarbs.text = "min carbs: \(String(format: "%.0f", ceil(minValue)))"
        maxCarbs.text = "max carbs: \(String(format: "%.0f", ceil(maxValue)))"
    }
    @objc func kcalSliderValueChanged(_ carbsSlider: RangeSlider) {
        var minValue = kcalSlider.lowerValue * 500 - 20
        var maxValue = kcalSlider.upperValue * 500 + 20
        
        if minValue < 0 {
            minValue = 0
        }
        
        if maxValue > 500 {
            maxValue = 500
        }
        
        minKcal.text = "min kcal: \(String(format: "%.0f", ceil(minValue)))"
        maxKcal.text = "max kcal: \(String(format: "%.0f", ceil(maxValue)))"
    }
    @objc func proteinSliderValueChanged(_ carbsSlider: RangeSlider) {
        var minValue = proteinSlider.lowerValue * 500 - 20
        var maxValue = proteinSlider.upperValue * 500 + 20
        
        if minValue < 0 {
            minValue = 0
        }
        
        if maxValue > 500 {
            maxValue = 500
        }
        
        minProtein.text = "min protein: \(String(format: "%.0f", ceil(minValue)))"
        maxProtein.text = "max protein: \(String(format: "%.0f", ceil(maxValue)))"
    }
    @objc func fatSliderValueChanged(_ carbsSlider: RangeSlider) {
        var minValue = fatSlider.lowerValue * 500 - 20
        var maxValue = fatSlider.upperValue * 500 + 20
        
        if minValue < 0 {
            minValue = 0
        }
        
        if maxValue > 500 {
            maxValue = 500
        }
        
        minFat.text = "min fat: \(String(format: "%.0f", ceil(minValue)))"
        maxFat.text = "max fat: \(String(format: "%.0f", ceil(maxValue)))"
    }
    
    private func setupSliders() {
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
        
        proteinSlider.translatesAutoresizingMaskIntoConstraints = false
        fatSlider.translatesAutoresizingMaskIntoConstraints = false
        kcalSlider.translatesAutoresizingMaskIntoConstraints = false
        carbsSlider.translatesAutoresizingMaskIntoConstraints = false
        
        carbsView.addSubview(carbsSlider)
        kcalView.addSubview(kcalSlider)
        fatView.addSubview(fatSlider)
        proteinView.addSubview(proteinSlider)
    }
    
    private func setSlidersLayout() {
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
    
    private func setupPickers() {
        mealTypePicker.setValue(UIColor.white, forKey: "textColor")
        cuisinePicker.setValue(UIColor.white, forKey: "textColor")
        
        mealTypePicker.delegate = self
        mealTypePicker.dataSource = self
        
        cuisinePicker.delegate = self
        cuisinePicker.dataSource = self
        
        mealTypePicker.selectRow(3, inComponent: 0, animated: false)
        cuisinePicker.selectRow(3, inComponent: 0, animated: false)
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
    
    func reciveIngredients(ingredints: [RecipeIngredient]) {
        choosedIngredients = ingredints
    }
    
    @IBAction func chooseIngredientsButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "showChooseIngredientView", sender: nil)
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        let minCarbValue = Int(minCarbs.text?.replacingOccurrences(of: "min carbs: ", with: "") ?? "0") ?? 0
        let maxCarbValue = Int(maxCarbs.text?.replacingOccurrences(of: "max carbs: ", with: "") ?? "0") ?? 0
        
        let minProteinValue = Int(minProtein.text?.replacingOccurrences(of: "min protein: ", with: "") ?? "0") ?? 0
        let maxProteinValue = Int(maxProtein.text?.replacingOccurrences(of: "max protein: ", with: "") ?? "0") ?? 0
        
        let minFatValue = Int(minFat.text?.replacingOccurrences(of: "min fat: ", with: "") ?? "0") ?? 0
        let maxFatValue = Int(maxFat.text?.replacingOccurrences(of: "max fat: ", with: "") ?? "0") ?? 0
        
        let minKcalValue = Int(minKcal.text?.replacingOccurrences(of: "min kcal: ", with: "") ?? "0") ?? 0
        let maxKcalValue: Int = Int(maxKcal.text?.replacingOccurrences(of: "max kcal: ", with: "") ?? "0") ?? 0
        
        let cousine = cuisines[cuisinePicker.selectedRow(inComponent: 0)]
        let mealType = mealTypes[mealTypePicker.selectedRow(inComponent: 0)]
        
        self.dismiss(animated: true, completion: {
            self.delegate?.loadFilters(filters: FilterSet(minCarbValue, maxCarbValue, minProteinValue, maxProteinValue, minKcalValue, maxKcalValue, minFatValue, maxFatValue, cousine, mealType, self.choosedIngredients))
       })
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
