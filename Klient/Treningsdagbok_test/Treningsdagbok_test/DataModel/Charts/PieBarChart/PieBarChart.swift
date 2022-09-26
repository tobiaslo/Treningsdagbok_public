//
//  PieBarChart.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 13/01/2022.
//

import SwiftUI

func makePieBarChart(data: [Int], labels: [String]) -> PieBarChart {
    
    var pieData: [PieBarChartData] = []
    
    for n in 0...data.count {
        pieData.append(PieBarChartData(data: data[n], label: labels[n]))
    }
    
    return PieBarChart(data: pieData)
}

struct PieBarChart: View {
    var data: [PieBarChartData]
    
    var total: Int {
        var tot = 0
        for n in data {
            tot += n.data
        }
        return tot
    }
    
    var body: some View {
        GeometryReader {geometry in
            VStack(spacing: 0.0) {
                ForEach(data, id: \.self) { d in
                    PieBarChartPart(dataPoint: d)
                        .frame(height: geometry.size.height * CGFloat(Float(d.data) / Float(total)))
                }
            }
            .frame(width: 100)
        }
        
    }
}

struct PieBarChart_Previews: PreviewProvider {
    static let d1 = PieBarChartData(data: 10, label: "test1")
    static let d2 = PieBarChartData(data: 30, label: "test2")
    static let d3 = PieBarChartData(data: 50, label: "test3")
    static let data = [d1, d2, d3]
    
    static var previews: some View {
        PieBarChart(data: data)
    }
}
