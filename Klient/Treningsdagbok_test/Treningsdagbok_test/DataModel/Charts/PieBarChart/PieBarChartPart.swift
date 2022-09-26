//
//  PieBarChartPart.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 13/01/2022.
//

import SwiftUI

struct PieBarChartPart: View {
    var dataPoint: PieBarChartData
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(dataPoint.color)
                .border(.black)
            Text(dataPoint.label)
        }
        
    }
}

struct PieBarChartPart_Previews: PreviewProvider {
    static var previews: some View {
        PieBarChartPart(dataPoint: PieBarChartData(data: 10, label: "test"))
    }
}
