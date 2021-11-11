import UIKit
import Charts

class UserStatsViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cookedRecipeLabel: UILabel!
    @IBOutlet weak var spentTimeInCookingLabel: UILabel!
    @IBOutlet weak var recipesInProgressLabel: UILabel!
    @IBOutlet weak var cookedRecipesCount: UILabel!
    @IBOutlet weak var spentTimeInCooking: UILabel!
    @IBOutlet weak var recipesInProgress: UILabel!
    @IBOutlet weak var noDataToShowLabel: UILabel!
    @IBOutlet weak var schemeView: UIView!
    
    lazy var pieChartView: PieChartView = {
        let chartView = PieChartView()
        return chartView
    }()
    
    private let dishTypes: [ChartDataEntry] = [
        PieChartDataEntry(value: Double(DataManager.shared.getCountOfDishType("main course")), label: "main course", icon: nil),
        PieChartDataEntry(value: Double(DataManager.shared.getCountOfDishType("side dish")), label: "side dish", icon: nil),
        PieChartDataEntry(value: Double(DataManager.shared.getCountOfDishType("dessert")), label: "dessert", icon: nil),
        PieChartDataEntry(value: Double(DataManager.shared.getCountOfDishType("salad")), label: "salad", icon: nil),
        PieChartDataEntry(value: Double(DataManager.shared.getCountOfDishType("soup")), label: "soup", icon: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cookedRecipeLabel.adjustsFontSizeToFitWidth = true
        spentTimeInCookingLabel.adjustsFontSizeToFitWidth = true
        recipesInProgressLabel.adjustsFontSizeToFitWidth = true
        
        setData()
        schemeView.addSubview(pieChartView)
        
        if dishTypeIsEmpty() {
            noDataToShowLabel.alpha = 1
        } else {
            setupChart()
        }
        
        setBlurredBackground()
    }

    
    private func setupChart() {
        //set possition
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        pieChartView.heightAnchor.constraint(equalToConstant: (view.frame.size.height - 60) / 2 - 70).isActive = true
        pieChartView.bottomAnchor.constraint(equalTo: schemeView.bottomAnchor, constant: -20).isActive = true
        pieChartView.centerXAnchor.constraint(equalTo: schemeView.centerXAnchor).isActive = true
        
        //set corners
        pieChartView.clipsToBounds = true
        pieChartView.layer.cornerRadius = 15
        
        //set colors
        pieChartView.backgroundColor = UIColor.clear
        pieChartView.transparentCircleColor = UIColor.clear
        pieChartView.holeColor = UIColor.clear
    }
    
    func setData() {
        let cookedRecipes = PieChartDataSet(entries: dishTypes, label: "")
        cookedRecipes.sliceSpace = 1
        cookedRecipes.colors = ChartColorTemplates.joyful()
        
        let data = PieChartData(dataSet: cookedRecipes)
        
        pieChartView.data = data
        
        let cookedRecipeInformation = DataManager.shared.getCookedRecipeInformation()
        cookedRecipesCount.text = String(cookedRecipeInformation.count)
        
        if cookedRecipeInformation.spentTime % 60 < 10 {
            spentTimeInCooking.text = String(format: "%.0f", Double(cookedRecipeInformation.spentTime / 60)) + ":0" + String( cookedRecipeInformation.spentTime % 60)
        } else {
            spentTimeInCooking.text = String(format: "%.0f", Double(cookedRecipeInformation.spentTime / 60)) + ":" + String( cookedRecipeInformation.spentTime % 60)
        }
        
        recipesInProgress.text = String(DataManager.shared.getStartedRecipesCount())
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setBlurredBackground() {
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
      
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    
    }
    
    private func dishTypeIsEmpty() -> Bool{
        for dishType in dishTypes {
            if dishType.y != 0 {
                return false
            }
        }
        return true
    }
}
