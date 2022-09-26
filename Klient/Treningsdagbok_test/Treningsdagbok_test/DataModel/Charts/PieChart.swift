//
//  PieChart.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 12/02/2022.
//

import SwiftUI
import Charts

class PieChartController: NSViewController {
    var pieChartView: PieChartView!
    
    override func loadView() {
        pieChartView = PieChartView()
        self.view = pieChartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d: [PieChartDataEntry] = []
        
        let data = PieChartData()
        let set = PieChartDataSet(entries: d, label: "test")
        set.colors = ChartColorTemplates.material()
        data.addDataSet(set)
        
        self.pieChartView.data = data
        self.pieChartView.drawHoleEnabled = false
        self.pieChartView.drawEntryLabelsEnabled = false
        self.pieChartView.usePercentValuesEnabled = true
        
        
    }
    
    func update(l: [String], d: [Int]) {
        
        var dataEntry: [PieChartDataEntry] = []
        
        for n in d.indices {
            dataEntry.append(PieChartDataEntry(value: Double(d[n]), label: l[n]))
        }
        
        
        let data = PieChartData()
        let set = PieChartDataSet(entries: dataEntry, label: "test")
        set.colors = ChartColorTemplates.material()
        data.addDataSet(set)
        self.pieChartView.data = data
        self.pieChartView.drawEntryLabelsEnabled = false
        self.pieChartView.usePercentValuesEnabled = true
    }
}

struct ModelPieController: NSViewControllerRepresentable {
    
    @StateObject var oversiktUke: OversiktUke
    
    func updateNSViewController(_ nsViewController: PieChartController, context: Context) {
        
        nsViewController.update(l: oversiktUke.uke.pie_labels, d: oversiktUke.uke.pie_data)
    }
    
    func makeNSViewController(context: Context) -> PieChartController {
        let c = PieChartController()
        return c
    }
}
