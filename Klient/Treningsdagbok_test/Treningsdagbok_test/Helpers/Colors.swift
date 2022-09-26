//
//  Colors.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 13/01/2022.
//

import Foundation
import SwiftUI



let colorArray: [Color] = [Color("Color-0"),
                           Color("Color-1"),
                           Color("Color-2"),
                           Color("Color-3"),
                           Color("Color-4"),
                           Color("Color-5"),
                           Color("Color-6"),
                           Color("Color-7"),
                           Color("Color-8"),
                           Color("Color-9"),
                           Color("Color-10"),
                           Color("Color-11"),
                           Color("Color-12"),
                           Color("Color-13"),
                           Color("Color-14"),
                           Color("Color-15")]

func getZoneColor(z: Int) -> Color {
    if (z == 0) {
        return .white
    } else if (z < 3) {
        return Color("Z1")
    } else if (z < 5) {
        return Color("Z2")
    } else if (z < 7) {
        return Color("Z3")
    } else if (z < 9) {
        return Color("Z4")
    } else if (z < 11) {
        return Color("Z5")
    } else {
        return .white
    }
}
