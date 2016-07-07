//
//  PieChartController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 3/7/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import Charts

class PieChartController: UIViewController {
    @IBOutlet weak var piechartView: PieChartView!
    var dogs = [dog]()
    var doged: dog?
    var category = [String]()
    //var doggies = [String]()
    var days = [String]()
    var cals = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Charts"
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
        
        setPieChart(category, values: cals, color: [UIColor.redColor()])
        
    }
    override func viewDidAppear(animated: Bool) {
        piechartView.reloadInputViews()
        print("Hello")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setPieChart(let dataPoints: [String], values: [Double], color: [UIColor]) {
        
        
        var dataEntries: [BarChartDataEntry] = []
        //var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            
            dataEntries.append(dataEntry)
            
            
            
        }
        
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Categories")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        piechartView.data = pieChartData
        pieChartDataSet.colors = color
        
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
