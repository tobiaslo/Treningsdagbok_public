//
//  StatstikkView.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 13/02/2022.
//

import SwiftUI

struct StatstikkView: View {
    
    @StateObject var viewController: ViewController
    
    @State var data: [StatistikkData]
    @State var fraUke: Int = 0
    @State var fraAar: Int = 0
    @State var tilUke: Int = 0
    @State var tilAar: Int = 0
    @State var statType: Int = 0
    
    @State var statName: String = "Total tid"
    @State var statTyper: [String] = []
    @State var spesifikkTyper: [String] = []
    @State var spesifikkBool: [Bool] = [true]
    
    @State var visSpesifikk: Bool = false
    
    
    var body: some View {
        VStack {
            Button(action: {
                viewController.statistikk = -1
            }) {
                Text("Tilbake")
            }
            Text("Statistikk")
                .font(.title)
            
            Divider()
            
            HStack {
                Text("Fra:")
                TextField("Uke", value: $fraUke, formatter: NumberFormatter())
                Text("-")
                TextField("År", value: $fraAar, formatter: NumberFormatter())
                Text("Til:")
                TextField("Uke", value: $tilUke, formatter: NumberFormatter())
                Text("-")
                TextField("År", value: $tilAar, formatter: NumberFormatter())
                
                DropDownMeny(val: $statName, placeholder: "Velg data", dropDownList: statTyper)
                
                Button(action: {
                    getStatistikk(fraUke: fraUke, fraAar: fraAar, tilUke: tilUke, tilAar: tilAar, statType: statTyper.firstIndex(of: statName)!) { t in
                        self.data = t
                    }
                    
                    if (statName == "Tid spesifikk") {
                        self.visSpesifikk = true
                        self.spesifikkBool = [false, false, false, false, false, false, false, false, false, false, false, false]
                    } else {
                        self.visSpesifikk = false
                        self.spesifikkBool = [true]
                    }
                }) {
                    Text("Vis")
                }
            }
            
            ModelLineController(data: $data, select: $spesifikkBool)
            
            if (visSpesifikk) {
                GridSelect(arry: spesifikkTyper, selected: $spesifikkBool)
            }
            
            StatistikkDataScroll(data: $data, select: $spesifikkBool)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray)
                )
            
        }
        .onAppear {
            getStatistikk(fraUke: fraUke, fraAar: fraAar, tilUke: tilUke, tilAar: tilAar, statType: 0) { t in
                self.data = t
                self.fraUke = t[0].fraUke
                self.fraAar = t[0].fraAar
                self.tilUke = t[0].tilUke
                self.tilAar = t[0].tilAar
                self.statTyper = t[0].statTyper
                self.spesifikkTyper = t[0].spesifikkTyper
            }
        }
    }
}

struct StatstikkView_Previews: PreviewProvider {
    static var previews: some View {
        StatstikkView(viewController: ViewController(), data: [StatistikkData(data: [DataPunkt(uke: 1, data: 10), DataPunkt(uke: 2, data: 20), DataPunkt(uke: 3, data: 15)], labels: ["1", "2", "3", "4"], fraUke: 0, fraAar: 0, tilUke: 0, tilAar: 0, statTyper: ["Total tid", "Total distanse", "Total stigning"], spesifikkTyper: [], name: "test")])
    }
}
