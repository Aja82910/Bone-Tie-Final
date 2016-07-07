//
//  Charts.swift
//  Pods
//
//  Created by Alex Arovas on 2/22/16.
//
//

import UIKit

class Charts: UIViewController {
    @IBOutlet weak var chartView: PieChartView!
   /* override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Charts"
        chartView.descriptionText = ""
        if let savedWalks = loadWalks() {
            expenses += savedWalks
        } else {
            chartView.noDataTextDescription = "No Activity Yet."
        }
        
        expenses.sortinPlace({ $0.category.compare($1.category) == NSComparisonResult.OrderedAscending })
        for expense in expenses {
            let categories: [String] = [expense.category]
            let cost: [Double] = [expense.cost]
            cats += categories
            costs += cost
        }
        setChart(cats, values: costs)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(datapoints: [String], values: [Double]) {
        chartView.noDataText = "No Activity Yet."
        var dataEntries: [ChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry = PieChartDataSet(yVals: , label: "Categories")
//            dataEntries.append(dataEntry)
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
*/

}
