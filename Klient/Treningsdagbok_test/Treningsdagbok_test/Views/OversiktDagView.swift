//
//  OversiktDagView.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 01/01/2022.
//

import SwiftUI
import Foundation

struct OversiktDagView: View {
    
    var dag: Int
    @StateObject var viewController: ViewController
    @StateObject var oversiktUke: OversiktUke
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(oversiktUke.uke.dager[dag].dato)
                .font(.title)
            Divider()
                .background(Color.white)
            
            ForEach(oversiktUke.uke.dager[dag].treninger, id: \.self) {t in
                
                VStack(alignment: .leading) {
                    Text(t.overskrift)
                        .font(.headline)
                    Text("Tid: \(t.tid)")
                    Text("Dist: \(t.dist, specifier: "%.2f")")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(getZoneColor(z: t.rpe))
                .contentShape(Rectangle())
                .onTapGesture {
                    viewController.treningsID = t.id
                }
                                
                Divider()
            }
            
            Text("+")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.gray)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewController.dato = oversiktUke.uke.dager[dag].dato
                    viewController.treningsID = 0
                }
            Spacer()
            
        }
    }
}

struct OversiktDagView_Previews: PreviewProvider {
    static let t = OversiktTrening(id: 1, nr: 1, overskrift: "trening1", tid: 30, dist: 3.5, rpe: 3)
    static let dag = OversiktDag(dato: "14.01", treninger: [t])

    static var previews: some View {
        OversiktDagView(dag: 0, viewController: ViewController(), oversiktUke: OversiktUke())
            .previewLayout(.fixed(width: 100, height: 200))
    }
}
