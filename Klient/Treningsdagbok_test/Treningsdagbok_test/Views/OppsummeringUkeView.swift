//
//  OppsummeringUkeView.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 12/02/2022.
//

import SwiftUI

struct OppsummeringUkeView: View {
    
    @StateObject var oversiktUke: OversiktUke
    
    var body: some View {
        VStack {
            Text("Oppsumering")
                .font(.title)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Antall treninger: \(oversiktUke.uke.tot_ant)")
                    Text("Total tid: \(oversiktUke.uke.tot_tid)")
                    Text("Total distanse: \(oversiktUke.uke.tot_dist, specifier: "%.2f")")
                }
                
                ModelPieController(oversiktUke: oversiktUke)
            }
        }
    }
}

struct OppsummeringUkeView_Previews: PreviewProvider {
    
    static var previews: some View {
        OppsummeringUkeView(oversiktUke: OversiktUke())
    }
}
