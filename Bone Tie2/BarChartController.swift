//
//  ChartsViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 2/22/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import Charts

class BarChartController: UIViewController {
        var dogs = [dog]()
        var doged: dog?
        var category = [String]()
        //var doggies = [String]()
        var days = [String]()
        var cals = [Double]()
        
        @IBOutlet weak var chartView: BarChartView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.title = "Charts"
            chartView.descriptionText = ""
            
            if let savedDogs = loadDogs() {
                dogs += savedDogs
            }
            
            //Here we compare the expenses' dates to list them in chronological order (Left to Right)
            dogs.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
            
            for doged in dogs {
                
                let formatter = NSDateFormatter()
                formatter.dateStyle = .ShortStyle
                let string = formatter.stringFromDate(doged.date)
                
                let weekdays: [String] = [string]
                let expense: [Double] = [doged.cals]
                
                days += weekdays
                cals += expense
                
            }
            print(days)
            print(cals)
            
            setChart(days, values: cals)
            setPieChart(category, values: cals, color: [UIColor.redColor()])
            
        }
    override func viewDidAppear(animated: Bool) {
        chartView.reloadInputViews()
        print("Hello")
    }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    func setPieChart(let dataPoints: [String], values: [Double], color: [UIColor]) {
        
        chartView.noDataText = "No Activity Yet."
        
        var dataEntries: [BarChartDataEntry] = []
        //var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            
            dataEntries.append(dataEntry)
            
            
           
        }
        
    
    }

        
        func setChart(dataPoints: [String], values: [Double]) {
            
            chartView.noDataText = "No Activity Yet."
            var dataEntries: [BarChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Expenses")
            let chartData = BarChartData(xVals: days, dataSet: chartDataSet)
            chartView.data = chartData
            
            chartDataSet.colors = ChartColorTemplates.colorful()
            chartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
            chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        }
    
        
    
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

