//
//  StatistikkDataScroll.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 11/04/2022.
//

import SwiftUI

struct StatistikkDataScroll: View {
    
    @Binding var data: [StatistikkData]
    @Binding var select: [Bool]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                HStack {
                    Text("Uke")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(width: 80)
                    Divider()
                    ForEach(data.indices, id: \.self) { i in
                        if select[i] {
                            Text(data[i].name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(colorArray[i])
                                .frame(width: 100)
                        }
                    }
                    
                }
                Divider()
                ForEach(data[0].data.indices, id: \.self) {i in
                    HStack {
                        Text(data[0].labels[i])
                            .frame(width: 100)
                        Divider()
                        ForEach(data.indices, id: \.self) {k in
                            if select[k] {
                                Text(String(data[k].data[i].data))
                                    .frame(width: 100)
                            }
                        }
                    }
                    Divider()
                }
            }
        }
    }
}

struct StatistikkDataScroll_Previews: PreviewProvider {
    
    @State static var data = [StatistikkData(data: [DataPunkt(uke: 1, data: 10), DataPunkt(uke: 2, data: 20), DataPunkt(uke: 3, data: 15)], labels: ["1", "2", "3", "4"], fraUke: 0, fraAar: 0, tilUke: 0, tilAar: 0, statTyper: ["Total tid", "Total distanse", "Total stigning"], spesifikkTyper: [], name: "test")]
    
    @State static var select = [true]
    
    static var previews: some View {
        StatistikkDataScroll(data: $data, select: $select)
    }
}
