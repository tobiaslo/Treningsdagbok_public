//
//  UkeView.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 01/01/2022.
//

import SwiftUI
import Foundation

struct UkeView: View {
    
    @StateObject var viewController: ViewController
    //@State var uke: [OversiktDag] = []
    @StateObject var oversiktUke: OversiktUke

    
    var body: some View {
        VStack {
            Button(action: {
                viewController.statistikk = 1
            }) {
                Text("Statistikk")
            }
            HStack {
                Button(action: {
                    oversiktUke.forrigeUke()
                }) {
                    Text("<")
                        .font(.title2)
                }
                
                Text("Uke: \(oversiktUke.uke.nr)")
                    .font(.title2)
                
                Button(action: {
                    oversiktUke.nesteUke()
                }) {
                    Text(">")
                        .font(.title2)
                }
                
            }
            
            
            HStack(alignment: .top) {
                ForEach(oversiktUke.uke.dager.indices, id: \.self) {d in
                    OversiktDagView(dag: d, viewController: viewController, oversiktUke: oversiktUke)
                    
                    Divider()
                        .background(Color.white)
                }
                
                OppsummeringUkeView(oversiktUke: oversiktUke)
                    .frame(minWidth: 300)
                
                
            }
        }
        .padding()
        .frame(minHeight: 400)
        
    }
}

struct UkeView_Previews: PreviewProvider {
    static let t1 = OversiktTrening(id: 1, nr: 1, overskrift: "test1", tid: 30, dist: 5.4, rpe: 3)
    static let t2 = OversiktTrening(id: 2, nr: 2, overskrift: "test2", tid: 50, dist: 0.2, rpe: 7)
    static let dag = OversiktDag(dato: "1.2", treninger: [t1, t2])

    static var previews: some View {
        UkeView(viewController: ViewController(), oversiktUke: OversiktUke())
    }
}
