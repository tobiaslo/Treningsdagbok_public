//
//  GridSelect.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 03/03/2022.
//

import SwiftUI

struct GridSelect: View {
    
    var arry: [String]
    
    
    @Binding var selected: [Bool]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0...(arry.count / 2), id: \.self) {a in
                    Toggle(arry[a], isOn: $selected[a])
                        .frame(width: 150, alignment: .trailing)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
            }
            
            HStack {
                ForEach(((arry.count / 2) + 1)...(arry.count-1), id: \.self) {a in
                    Toggle(arry[a], isOn: $selected[a])
                        .frame(width: 150, alignment: .trailing)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
            }
        }

        
    }
}

struct test_GridSelect: View {
    
    var array = ["test1", "test2kldslk", "test3", "test4", "test5"]
    
    @State var selected: [Bool] = [false, false, false, false, false]
    
    var list: [String] {
        var res: [String] = []
        for n in selected.indices {
            if selected[n] {
                res.append(array[n])
            }
        }
        return res
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(list.indices, id: \.self) {e in
                    Text(list[e])
                }
            }
            GridSelect(arry: array, selected: $selected)
        }
        
        
    }
}

struct GridSelect_Previews: PreviewProvider {
    static var previews: some View {
        test_GridSelect()
    }
}
