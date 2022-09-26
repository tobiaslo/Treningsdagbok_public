//
//  PieBarChartData.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 13/01/2022.
//

import Foundation
import SwiftUI

struct PieBarChartData: Hashable {
    var data: Int
    var label: String
    var color: Color = colorArray[Int.random(in: 0...15)]
}
