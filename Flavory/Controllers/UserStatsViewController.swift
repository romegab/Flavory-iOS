import UIKit
import Charts

class UserStatsViewController: UIViewController, ChartViewDelegate {
    
    lazy var pieChartView: PieChartView = {
        let chartView = PieChartView()
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        
        view.addSubview(pieChartView)
        setupChart()
        setBlurredBackground()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print (entry)
    }
    
    private func setupChart() {
        //set possition
        pieChartView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - 20, height: view.frame.size.width - 20)
        pieChartView.center = view.center
        
        //set corners
        pieChartView.clipsToBounds = true
        pieChartView.layer.cornerRadius = 15
        
        //set colors
        pieChartView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        pieChartView.transparentCircleColor = UIColor.darkGray.withAlphaComponent(0.1)
        pieChartView.holeColor = UIColor.clear
    }
    
    func setData() {
        let set1 = PieChartDataSet(entries: yValues, label: "")
        set1.sliceSpace = 1
        set1.colors = ChartColorTemplates.material()

        let data = PieChartData(dataSet: set1)
        
        pieChartView.data = data
    
    }
    
    let yValues: [ChartDataEntry] = [
        PieChartDataEntry(value: 5, label: "salad", icon: nil),
        PieChartDataEntry(value: 3, label: "soup", icon: nil),
        PieChartDataEntry(value: 6, label: "main course", icon: nil),
    ]

    
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
}
