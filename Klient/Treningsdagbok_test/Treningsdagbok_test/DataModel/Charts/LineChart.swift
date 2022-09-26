//
//  LineChart.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 13/02/2022.
//

import SwiftUI
import Charts
import Foundation
import Cocoa

class LineViewController: NSViewController
{
    @IBOutlet var lineChartView: LineChartView!
    
    override func loadView() {
        lineChartView = LineChartView()
        self.view = lineChartView
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        let yse1: [ChartDataEntry] = []
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(entries: yse1, label: "Hello")
        ds1.colors = [NSUIColor.red]
        ds1.circleRadius = 2
        data.addDataSet(ds1)
    
        self.lineChartView.data = data
        
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        
        self.lineChartView.xAxis.labelPosition = .bottom

    }
    
    override open func viewWillAppear()
    {
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    func update(statData: [StatistikkData], select: [Bool]) {
        let data: LineChartData = LineChartData()
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
        
        for i in statData.indices {
            if select[i] {
                var dataEntry: [ChartDataEntry] = []
                
                for n in statData[i].data.indices {
                    dataEntry.append(ChartDataEntry(x: Double(statData[i].data[n].uke), y: Double(statData[i].data[n].data)))
                }
                
                let dataSet: LineChartDataSet = LineChartDataSet(entries: dataEntry, label: statData[i].name)
                dataSet.colors = [NSUIColor(colorArray[i])]
                dataSet.circleRadius = 5
                dataSet.lineWidth = 4
                data.addDataSet(dataSet)
            }
        }
        
        
        data.setDrawValues(false)
        
        self.lineChartView.data = data
        self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: statData[0].labels)
        self.lineChartView.xAxis.granularity = 1
    }
}

struct ModelLineController: NSViewControllerRepresentable {
    
    @Binding var data: [StatistikkData]
    @Binding var select: [Bool]
    
    func updateNSViewController(_ nsViewController: LineViewController, context: Context) {
        nsViewController.update(statData: data, select: select)
    }
    
    func makeNSViewController(context: Context) -> LineViewController {
        let c = LineViewController()
        return c
    }
}
