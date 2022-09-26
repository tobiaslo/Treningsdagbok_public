//
//  DropDownMeny.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 29/01/2022.
//

import SwiftUI

struct Tester: View {
    
    let p = "Select Client"
    let d = ["test1", "test2", "test3"]
    @State var val = ""
    
    
    var body: some View {
        VStack {
            Text(val)
            DropDownMeny(val: $val, placeholder: p, dropDownList: d)
        }
    }
}

struct DropDownMeny: View {
    
    @Binding var val: String
    
    var placeholder: String
    var dropDownList: [String]
    
    var body: some View {
        Menu {
            ForEach(dropDownList, id: \.self) { client in
                Button(client) {
                    //self.value = client
                    self.val = client
                }
            }
        } label: {
            Text(val == "" ? placeholder : val)
                    .foregroundColor(.white)
                    .padding()
        }

    }
}

struct DropDownMeny_Previews: PreviewProvider {
    
    static var previews: some View {
        Tester()
    }
}
